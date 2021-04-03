# xml_daten
Projekt zum Kurs XML-Daten aufbereiten

    .
    ├── results # Enthält beispielhafte Visualisierungen, die mithilfe des Skripts create_wordlists.ipynb 
                aus den generierten Wortlisten erstellt sind.
    ├── xml_siblings # Enthält .csv Dateien und Visualisierungen zu den siblings und neighbors 
                der XML-Elemente.
    ├── xslt  # .xsl und .xpl sind die Transformationsskripte.
        ├── change_folderstructure.ipynb # ändert Ordnerstruktur in gsa_original zu gsa 
                zur Weiterverwendung in der XPROC-Pipeline
        ├── gsa_original # Hier müssen die gewünschten Quelldokumente eingefügt werden (für die vorliegende Arbeit: 
                dokumentarische Transkriptionen der GSA) 
        ├── gsa # Neue Ordner-Struktur.
        ├── output # Enthält die  aus der Transformation entstandenen XML-Files.
    ├── extract_elementnames.py # Generiert Inhalte im Ordner xml_siblings
    └── README.md
