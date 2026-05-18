import config
import torch

from pathlib import Path
from segment_anything import sam_model_registry



PROJECT_ROOT = Path(__file__).resolve().parent
model_path = PROJECT_ROOT / config.SAM_CHECKPOINT

def freeze_model(model):
    for param in model.parameters():
        param.requires_grad = False


def unfreeze_model(model):
    for param in model.parameters():
        param.requires_grad = True


def load_sam(checkpoint=model_path, model_type="vit_b"):
    device = torch.device("cuda" if torch.cuda.is_available() else "cpu")

    if torch.cuda.is_available():
        print(f"Uzywane urzadzenie: GPU")
        print(f"Uzywana karta graficzna: {torch.cuda.get_device_name(0)}")
    else:
        print("Uzywane urzadzenie: CPU")

    sam = sam_model_registry[model_type](checkpoint=str(checkpoint))
    return sam.to(device)

def prepare_model():
    sam = load_sam()
    freeze_model(sam.image_encoder)
    unfreeze_model(sam.prompt_encoder)
    unfreeze_model(sam.mask_decoder)

    return sam

def get_trainable_params(sam):
    return [p for p in sam.parameters() if p.requires_grad]

def run_dir(run_id):
    return PROJECT_ROOT / config.OUTPUT_DIR / f"run_{run_id:03d}"

def checkpoint_path(run_id):
    return run_dir(run_id) / config.CHECKPOINT_NAME

def save_checkpoint(sam, run_id):
    path = checkpoint_path(run_id)
    path.parent.mkdir(parents=True, exist_ok=True)
    torch.save(
        {
            "run_id": run_id,
            "prompt_encoder": sam.prompt_encoder.state_dict(),
            "mask_decoder": sam.mask_decoder.state_dict(),
        },
        path,
    )
    print(f"Zapisano run {run_id}: {path}")
    return path

def load_checkpoint(run_id, sam=None):
    path = checkpoint_path(run_id)

    if not path.is_file():
        raise FileNotFoundError(f"Brak checkpointu dla run {run_id}: {path}")
    if sam is None:
        sam = prepare_model()

    ckpt = torch.load(path, map_location="cpu")
    sam.prompt_encoder.load_state_dict(ckpt["prompt_encoder"])
    sam.mask_decoder.load_state_dict(ckpt["mask_decoder"])

    print(f"Wczytano run {run_id}: {path}")
    return sam

