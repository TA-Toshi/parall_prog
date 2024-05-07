1. Лабораторные выполнялись в VS code
2. размеры матриц:
     - CUDA -> 9543x9543
     - MPI -> 1695x1695
     - OPEN_MP -> 1233x1233
3. Особенности запуска:
     - MPI:
         - компиляция -> g++ -I"C:\Program Files (x86)\Microsoft SDKs\MPI\Include" -o kernel.exe kernel.cpp "C:\Program Files (x86)\Microsoft SDKs\MPI\Lib\x64\msmpi.lib"
         - запуск -> mpiexec -n 1 kernel.exe
     - OPEN_MP:
         - компиляция -> Ctrl+Shift+B (VScode)
         - запуск -> ./kernel
