# SAM-Fine-tuning

## Wersje używanych technologii:
- System operacyjny: Windows 11
- Środowisko uruchomieniowe: Python 3.12
- Platforma obliczeniowa: AMD ROCm 7.2.1 (wersja dla Windows)
- Biblioteki ML:
  - PyTorch 2.9.1+rocm7.2.1
  - Torchvision 0.24.1+rocm7.2.1
  - Torchaudio 2.9.1+rocm7.2.1

## Instrukcja uruchamiania z podanymi technologiami
1. Przygotowanie wirtualnego środowiska
```powershell
python -m venv venv
.\venv\Scripts\activate
```
2. Uruchom przygotowany skrypt PowerShell, który zainstaluje specyficzne paczki .whl bezpośrednio z serwerów AMD, pobierze dataset Kvasir-SEG oraz SAM:
```powershell
.\setup.ps1
```
**Uwaga:** Jeśli system Windows blokuje uruchomienie skryptu, odblokuj uprawnienia poleceniem:
```powershell 
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

3. Uruchom program:
```powershell
python main.py
```