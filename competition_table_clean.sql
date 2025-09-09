-- LIMPIEZA TABLA COMPETITION
-- 1. Crear nueva tabla desde los datos originales 
CREATE TABLE `preguntas-de-negocio.desempeno_canciones.competition_copia` AS
SELECT * FROM `preguntas-de-negocio.desempeno_canciones.competition`;

-- 2. Identificar valores nulos
SELECT COUNTIF(track_id IS NULL) AS nulos_track_id,
  COUNTIF(in_apple_playlists IS NULL) AS nulos_apple_playlist,
  COUNTIF(in_apple_charts IS NULL) AS nulos_apple_charts,
  COUNTIF(in_deezer_playlists IS NULL) AS nulos_deezer_playlists,
  COUNTIF(in_deezer_charts IS NULL) AS nulos_deezer_charts, 
  COUNTIF(in_shazam_charts IS NULL) AS nulos_shazam_charts
  FROM `preguntas-de-negocio.desempeno_canciones.competition_copia`;

-- 3. Reemplazar valores nulos por 0
UPDATE `preguntas-de-negocio.desempeno_canciones.competition_copia` 
SET in_shazam_charts = 0
WHERE in_shazam_charts IS NULL;

-- 4. Identificar valores duplicados. (Sin valores duplicados)
SELECT track_id, in_apple_playlists,
COUNT(*)
FROM `preguntas-de-negocio.desempeno_canciones.competition_copia`
GROUP BY track_id, in_apple_playlists
HAVING COUNT(*) > 1;

-- 5. Identificar valores atípicos en variables numéricas
SELECT
MIN(track_id) AS min_id,
MAX(track_id) AS max_id,
MIN(in_apple_playlists) AS min_appleplay,
MAX(in_apple_playlists) AS max_appleplay,
AVG(in_apple_playlists) AS avg_appleplay,
MIN(in_apple_charts) AS min_applecharts,
MAX(in_apple_charts) AS max_applecharts,
AVG(in_apple_charts) AS avg_applecharts,
MIN(in_deezer_playlists) AS min_dee_playlist,
MAX(in_deezer_playlists) AS max_dee_playlist,
AVG(in_deezer_playlists) AS avg_dee_playlist,
MIN(in_deezer_charts) AS min_dee_charts,
MAX(in_deezer_charts) AS max_dee_charts,
AVG(in_deezer_charts) AS avg_dee_charts,
MIN(in_shazam_charts) AS min_shazam,
MAX(in_shazam_charts) AS max_shazam,
AVG(in_shazam_charts) AS avg_shazam,
FROM `preguntas-de-negocio.desempeno_canciones.competition_copia`;

-- 6. Se encontró el valor atípico en track_id: '0:00'. Decidimos eliminar este registro.
DELETE FROM `preguntas-de-negocio.desempeno_canciones.competition_copia`
WHERE track_id = '0:00';

-- 7. Convertir tipos de dato: de string a integer. Columna track_id. Creamos nueva tabla convirtiendo el tipo de dato.
CREATE TABLE `preguntas-de-negocio.desempeno_canciones.competition_clean` AS
SELECT 
CAST(track_id AS INT64) AS track_id_int,
in_apple_playlists, in_apple_charts, in_deezer_playlists, in_deezer_charts, in_shazam_charts
FROM `preguntas-de-negocio.desempeno_canciones.competition_copia`;

-- 8. En la nueva tabla con los datos procesados, renombramos la columna como estaba anteriormente
ALTER TABLE `preguntas-de-negocio.desempeno_canciones.competition_clean`
RENAME COLUMN track_id_int TO track_id;

-- 9. Crear vista con los datos limpios
CREATE VIEW `preguntas-de-negocio.desempeno_canciones.competition_view` AS
SELECT * 
FROM `preguntas-de-negocio.desempeno_canciones.competition_clean`;


