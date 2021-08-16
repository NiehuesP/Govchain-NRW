## Use Case: Parkausnahmegenehmigung 

In dicht besuchten Orten, wie Innenstädten oder Stadtquartieren, sind Parkflächen ein rares Gut. 
Einige Fahrzeuge werden auf Flächen abgestellt, die nicht zum Parken freigegeben oder speziell den Anwohnerinnen und Anwohnern vorbehalten sind.
Laut §46 der Straßenverkehrsordnung ist es möglich in Einzelfällen oder bestimmten Antragstellern eine Ausnahme zu erteilen.
I. d. R. handelt es sich hierbei um spezielle Parkausweise wie:
* Parkausweise für Handwerker,
* Parkausweise für ambulante soziale Dienste oder
* sogenannte "Bewohnerparkausweise".

Solche Ausweise werden im Fahrzeug hinterlegt und sind relativ leicht fälschbar. Speziell für Abfrageberechtigte, wie bspw. die Verkehrsüberwachung, ist die Gültigkeit nur schwierig überprüfbar. An dieser Stelle soll die Blockchain-Technologie ansetzen.
Ziel ist es, dass via QR-Code eine Überprüfung stattfinden kann und ausgibt, ob der Parkausweis echt ist.
Alle notwendigen Information werden in einem QR-Code kodiert und zusätzlich in der Blockchain verankert.

![Ausnahme_erfolgreich](https://user-images.githubusercontent.com/86418664/129541286-afa48b95-8249-4773-bbdc-e0e6f67b58fd.jpg)

#### Der bisherige analoge Prozess gliedert sich sich in folgende Schritte.  

1. Es wird ein Antrag gestellt, in der für den jeweiligen Parkausweis benötigte Dokumente angehängt werden.
2. Nach erfolgreicher Prüfung der jeweiligen Voraussetzungen wird ein Parkausweis ausgestellt und in einer kommunalen Verwaltungssoftware (VMS) hinterlegt.
3. Der Parkausweis wird im Fahrzeug hinterlegt.
4. Bei Prüfung der zuständigen Verkehrsüberwachung wird der Parkausweis betrachtet.

 
#### Hintergründen und Überlegungen zu diesem Prozess 

Parkausweise sind ein Dokument, dass in einer hohen Frequenz in einer Stadt oder Kommune ausgestellt wird. Damit soll den einzelnen Interessensgruppen die Möglichkeit gegeben werden Parkräume einfach zu nutzen.
Das derzeitige Problem ist jedoch, dass Parkausweise relativ leicht fälschbar sind. Es gibt zwar Möglichkeiten diese mit höheren Sicherheitsmerkmalen auszustatten, jedoch ist dieser Prozess aufwendig und muss nach Ablauf und Neuausstellung eines Parkausweises wiederholt werden.
Durch die Blockchain-Technologie ergibt sich die Möglichkeit die Verifikation kostengünstiger zu verlagern und bei Bedarf einfach abzurufen.


#### Der digitalisierte Prozess gliedert sich wie folgt.  

![Prozess_der_Ausstellung und Prüfung](https://user-images.githubusercontent.com/86418664/129541948-9226b91e-6212-4b95-ab9f-2599881f95b6.png)

1. Bei der Antragsbearbeitung wird der Antrag geprüft und mit der Software VMS bearbeitet. 
   Die Genehmigung wird als QR-Code ausgestellt und in der Blockchain hinterlegt. 
2. Der auszustellende Parkausweis wird mit dem QR-Code versehen.
3. Bei einer Überprüfung kann die prüfende Person via mobile App auf dem Smartphone den QR-Code scannen und erhält direkt das Ergebnis.

Das Ergebnis kann wie im obigen Bild entweder eine erfolgreiche Verifizierung darstellen oder einen nicht legalen QR-Code, wie im unteren Bild dargestellt.

![QR-Code_nicht_verifiziert](https://user-images.githubusercontent.com/86418664/129543285-b5928dae-2d89-4487-897a-5cb20eb114c3.png)

#### Fazit und Argumente für den Use Case

- Anbindung an einer Software, die von vielen deutschen Kommunen bereis genutzt werden.
- Einfache Schnittstelle.
- Weitere Anbindungen an anderer Verwaltungs-Software denkbar.
- Kostengünstig.
- Schnellere Ausstellung von Dokumenten.
- Einfache Überprüfbarkeit im laufenden Betrieb.
- Keine teuere Hardware zur Überprüfung notwendig.

