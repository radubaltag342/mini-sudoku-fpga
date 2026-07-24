# Joc Mini-Sudoku pe Placă FPGA (VHDL)

## Descriere
Acest proiect reprezintă implementarea unui joc de tip Sudoku simplificat (grilă 4x4) direct la nivel hardware, descris complet în limbajul VHDL. Proiectul este dezvoltat și testat pe platforma de dezvoltare **Nexys 4 (Xilinx Artix-7 XC7A100T)**.

Interacțiunea cu jocul se face fizic, utilizatorul folosind switch-urile pentru selectarea valorilor (1-4) și butoanele direcționale pentru navigarea pe grilă. Afișarea stării de joc este duală:
* **Monitor VGA:** Randează grila de joc colorată la o rezoluție de 640x480 px @ 60Hz.
* **Afișaj cu 7 segmente (SSD):** Indică starea finală a jocului (mesajele "WIN" sau "LOSE") prin multiplexare rapidă.

## Arhitectura Hardware
Sistemul este împărțit în mai multe module VHDL interconectate printr-un fișier top-level:
* **Divizor de frecvență (`div_frecventa`):** Reduce frecvența ceasului de sistem de la 100 MHz la 25 MHz pentru a asigura pixel clock-ul necesar standardului VGA.
* **Debouncer (`debouncer`):** Filtrează zgomotul mecanic (contact bounce) generat la apăsarea celor 5 butoane fizice prin numărarea stabilității semnalului.
* **Logica Jocului (`logica_jocului`):** Reprezintă un Finite State Machine (FSM) care gestionează grila 4x4, mutarea cursorului, inserarea valorilor și detectarea condițiilor de câștig/eșec în raport cu soluția unică hardcodată.
* **VGA Controller (`vga`):** Generează semnalele de sincronizare orizontală și verticală (HS, VS) și randează grila și cursorul pe ecran, folosind un cod de 4 biți per canal RGB.
* **SSD Controller (`afisaj_ssd`):** Afișează mesaje text pe cele 8 afișoare ale plăcii, controlând anozii și catozii corespunzători.

## Tehnologii Utilizate
* **Limbaj:** VHDL
* **Mediu de dezvoltare:** Xilinx Vivado
* **Hardware:** Placă de dezvoltare Nexys 4 (Artix-7), Monitor VGA

## Documentație și Cod Sursă
Acest repository conține toate fișierele `.vhd` necesare sintezei și implementării pe FPGA. Pentru o explicație detaliată a mașinii de stări, a timing-ului VGA și a schemelor bloc, vă rog să consultați documentația completă disponibilă în fișierul `Mini_Sudoku_Nexys4.pdf`.
