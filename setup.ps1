$rocm_urls = @(
    "https://repo.radeon.com/rocm/windows/rocm-rel-7.2.1/rocm_sdk_core-7.2.1-py3-none-win_amd64.whl",
    "https://repo.radeon.com/rocm/windows/rocm-rel-7.2.1/rocm_sdk_devel-7.2.1-py3-none-win_amd64.whl",
    "https://repo.radeon.com/rocm/windows/rocm-rel-7.2.1/rocm_sdk_libraries_custom-7.2.1-py3-none-win_amd64.whl",
    "https://repo.radeon.com/rocm/windows/rocm-rel-7.2.1/rocm-7.2.1.tar.gz",
    "https://repo.radeon.com/rocm/windows/rocm-rel-7.2.1/torch-2.9.1%2Brocm7.2.1-cp312-cp312-win_amd64.whl",
    "https://repo.radeon.com/rocm/windows/rocm-rel-7.2.1/torchaudio-2.9.1%2Brocm7.2.1-cp312-cp312-win_amd64.whl",
    "https://repo.radeon.com/rocm/windows/rocm-rel-7.2.1/torchvision-0.24.1%2Brocm7.2.1-cp312-cp312-win_amd64.whl"
)

$dataset_url = "https://datasets.simula.no/downloads/kvasir-seg.zip"
$dataset_zip = "kvasir-seg.zip"
$dataset_dir = "Kvasir-SEG"
$model_url = "https://dl.fbaipublicfiles.com/segment_anything/sam_vit_b_01ec64.pth"
$model_file = "sam_vit_b_01ec64.pth"

[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12 -bor [Net.SecurityProtocolType]::Tls13

Write-Host "Instalacja srodowiska PyTorch dla AMD ROCm."
python -m pip install --no-cache-dir $rocm_urls

if (-Not (Test-Path $dataset_dir)) {
    if (-Not (Test-Path $dataset_zip)) {
        Write-Host "Pobieranie archiwum (curl)..."
        curl.exe -k -L -o $dataset_zip $dataset_url
    }

    if (Test-Path $dataset_zip) {
        Write-Host "Wypakowywanie datasetu."
        Expand-Archive -Path $dataset_zip -DestinationPath "." -Force
        Remove-Item -Path $dataset_zip -Force
    }
}

if (-Not (Test-Path $model_file)) {
    Write-Host "Pobieranie wag modelu (curl)..."
    curl.exe -k -L -o $model_file $model_url
}

Write-Host "Gotowe."