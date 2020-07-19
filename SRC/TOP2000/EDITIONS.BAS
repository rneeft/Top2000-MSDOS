DECLARE FUNCTION LatestEdition () AS INTEGER
TYPE EditionType
    year AS INTEGER
END TYPE

FUNCTION LatestEdition () AS INTEGER

  OPEN "C:\SRC\2TK\TOP2000.DAT" FOR ISAM EditionType "Editions" AS #1
  DIM edition AS EditionType
  MOVELAST #1
  RETRIEVE #1, edition
  CLOSE #1

  LatestEdition = edition.year

END FUNCTION

