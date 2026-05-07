Simple packaged-build helper scripts copied into the Win64 build by the PreArchive hook.

- `run_windowed.bat` — launch the packaged build in a 1280x720 window
- `run_log.bat` — launch with a log window
- `run_d3d11_windowed.bat` — launch in D3D11 windowed mode

These scripts live in `Default/win64` so the default Jenkins PreArchive step copies them.
