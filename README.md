# PINGscript
Zastosowanie: Skrypt służy do okresowego sprawdzania komunikacji z urządzeniami końcowymi. Komunikacja następuje za pomocą protokołu ICMP. Wysyła pakiety ICMP Echo Request i odbiera ICMP Echo Reply.

 

Obsługa: Skrypt do działania potrzebuje następujących plików: 

    Plik: hosts W pliku tym zapisane są informacje o hostach do których zostanie wysłany PING request

    Każdy host zapisany jest w osobnej linijce. Hosty są zapisane w postaci adresu IPv4

    Plik: addresses W pliku tym zapisane są informacje o użytkownikach do których zostanie wysłany mail z powiadomieniem w przypadku braku komunikacji z którymś z hostów. Każdy host zostanie zapisany i zgłoszony

    Plik: config W pliku tym zapisane są informacje o serwerze smtp (user, password, smtp)

 

Uruchamianie: Skrypt uruchamiamy a następnie w trybie automatycznym wykonuje odczyt danych z plików a następnie sprawdza komunikacje. 

 

Błędy: Program nie obsługuje następujących błędów

    Brak komunikacji z internetem

    Brak plików hosts oraz addresses. Skrypt nie rozpoznaje innych nazw.

    Inne błędy związane z odczytem danych z plików

 ![Bez nazwy](https://github.com/mormych/PINGscript/assets/71809600/06a25fc5-39fe-4339-977e-619cfd30c675)


 
