--Using Error Handling

BEGIN TRY
	BEGIN TRAN AddIM

	INSERT INTO tblFilm (FilmName , FilmReleaseDate)
	VALUES ('Iron Man 3' , '2013-04-25')

	UPDATE tblFilm
	SET FilmDirectorID = 4
	WHERE FilmName = 'Iron Man 3'

	COMMIT TRAN AddIM
END TRY 
BEGIN CATCH
	ROLLBACK TRAN AddIM
	PRINT 'ADDING IRON MAN FAILED CHECK DATA TYPES'
END CATCH

