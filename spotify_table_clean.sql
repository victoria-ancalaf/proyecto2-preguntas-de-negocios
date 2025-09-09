-- LIMPIEZA TABLA SPOTIFY
-- 1. Crear nueva tabla desde los datos originales 
CREATE TABLE `preguntas-de-negocio.desempeno_canciones.spotify_copia` AS
SELECT * FROM `preguntas-de-negocio.desempeno_canciones.spotify`;

-- 2. Identificar valores nulos (Sin valores nulos)
SELECT COUNTIF(track_id IS NULL) AS nulos_track_id,
COUNTIF(track_name IS NULL) AS nulos_track_name,
COUNTIF(artist_s__name IS NULL) AS nulos_artist_name,
COUNTIF(artist_count IS NULL) AS nulos_artist_count,
COUNTIF(released_year IS NULL) AS nulos_released_year,
COUNTIF(released_month IS NULL) AS nulos_released_month,
COUNTIF(released_day IS NULL) AS nulos_released_day,
COUNTIF(in_spotify_playlists IS NULL) AS nulos_spotify_playlist,
COUNTIF(in_spotify_charts IS NULL) AS nulos_spotify_charts,
COUNTIF(streams IS NULL) AS nulos_streams FROM `preguntas-de-negocio.desempeno_canciones.spotify_copia`;

-- 3. Identificar valores duplicados.
SELECT *
FROM (
  SELECT 
    *,
    COUNT(*) OVER(PARTITION BY track_name, artist_s__name) AS duplicados
  FROM `preguntas-de-negocio.desempeno_canciones.spotify_copia`
)
WHERE duplicados > 1;


-- 4. Duplicados: 4 registros con mismo nombre de canción y artista. Al revisar las otras columnas se encontró que algunos datos coincidian pero otros no. Se decide eliminar uno de los duplicados.
-- Seleccionamos el track_id del segundo duplicado (3814670, 5080031, 4586215, 8173823)
-- Se eliminan los registros duplicados, quedando 949 registros
DELETE FROM `preguntas-de-negocio.desempeno_canciones.spotify_copia`
WHERE track_id IN ('3814670', '5080031', '4586215', '8173823');

--5. Identificar valores atipicos en variables categoricas
-- Se eliminaron los símbolos raros, pero se mantuvieron los caracteres especiales: .,()!\'"?:-
SELECT track_name,artist_s__name,
REGEXP_REPLACE(track_name, r'[^a-zA-Z0-9 .,()!\'"?:-]', '') AS track_name_limpio,
REGEXP_REPLACE(artist_s__name, r'[^a-zA-Z0-9 .,()!\'"?:-]', '') AS artist_name_limpio
FROM `preguntas-de-negocio.desempeno_canciones.spotify_copia`;

--6. Tratar valores atipicos en variables categoricas. 
UPDATE `preguntas-de-negocio.desempeno_canciones.spotify_copia`
SET
track_name = REGEXP_REPLACE(track_name, r'[^a-zA-Z0-9 .,()!\'"?:-]', ''),
artist_s__name = REGEXP_REPLACE(artist_s__name, r'[^a-zA-Z0-9 .,()!\'"?:-]', '')
WHERE  
REGEXP_CONTAINS(track_name, r'[^a-zA-Z0-9 .,()!\'"?:-]') OR
REGEXP_CONTAINS(artist_s__name, r'[^a-zA-Z0-9 .,()!\'"?:-]');

-- 7. Identificar valores atípicos en variables numéricas
SELECT
MIN(track_id) AS min_id,
MAX(track_id) AS max_id,
MIN(artist_count) AS min_artist_count,
MAX(artist_count) AS max_artist_count,
AVG(artist_count) AS avg_artist_count,
MIN(released_year) AS min_released_year,
MAX(released_year) AS max_released_year,
AVG(released_year) AS avg_released_year,
MIN(released_month) AS min_rmonth,
MAX(released_month) AS max_rmonth,
AVG(released_month) AS avg_rmonth,
MIN(released_day) AS min_rday,
MAX(released_day) AS max_rday,
AVG(released_day) AS avg_rday,
MIN(in_spotify_playlists) AS min_spotify_playlist,
MAX(in_spotify_playlists) AS max_spotify_playlist,
AVG(in_spotify_playlists) AS avg_spotify_playlist,
MIN(in_spotify_charts) AS min_spotify_charts,
MAX(in_spotify_charts) AS max_spotify_charts,
AVG(in_spotify_charts) AS avg_spotify_charts,
MIN(streams) AS min_streams,
MAX(streams) AS max_streams,
FROM `preguntas-de-negocio.desempeno_canciones.spotify_copia`;

-- 8. Se encontró el valor atípico en columna track_id: '0:00' y en columna streams: 'BPM110KeyAModeMajorDanceability53Valence75Energy69Acousticness7Instrumentalness0Liveness17Speechiness3'. Decidimos eliminar estos registros.
DELETE FROM `preguntas-de-negocio.desempeno_canciones.spotify_copia`
WHERE track_id = '0:00';
-- Buscar el track_id a eliminar (track_id:4061483)
SELECT track_id FROM `preguntas-de-negocio.desempeno_canciones.spotify_copia`
WHERE streams = "BPM110KeyAModeMajorDanceability53Valence75Energy69Acousticness7Instrumentalness0Liveness17Speechiness3";
-- Eliminar valor atipico en streams
DELETE FROM `preguntas-de-negocio.desempeno_canciones.spotify_copia`
WHERE track_id = '4061483';

-- 9. Convertir tipos de dato: de string a integer. Columnas streams y track_id. Creamos nueva tabla convirtiendo el tipo de dato.
-- También se crea una nueva variable de fecha de lanzamiento (released_date)
CREATE TABLE `preguntas-de-negocio.desempeno_canciones.spotify_clean` AS
SELECT
    CAST(track_id AS INT64) AS track_id_int,
    track_name, artist_s__name, artist_count, released_year, released_month, released_day, 
    CAST(CONCAT(released_year, "-", released_month, "-", released_day) AS DATE) AS released_date,
    in_spotify_playlists, in_spotify_charts,
    CAST(streams AS INT64) AS streams_int,
FROM `preguntas-de-negocio.desempeno_canciones.spotify_copia`;

-- 10. En la nueva tabla con los datos procesados, renombramos las columnas como estaban anteriormente
ALTER TABLE `preguntas-de-negocio.desempeno_canciones.spotify_clean`
RENAME COLUMN track_id_int TO track_id,
RENAME COlUMN streams_int TO streams;

-- 11. Re-revisón de nombre de canciones, se reemplaza registro vacío por "Nombre desconnocido"
UPDATE
  `preguntas-de-negocio.desempeno_canciones.spotify_clean`
SET
  track_name = "Nombre desconocido"
WHERE
  track_name = '';

SELECT * FROM `preguntas-de-negocio.desempeno_canciones.spotify_clean`
WHERE track_name = "Nombre desconocido";

-- 11. Crear vista con los datos limpios
CREATE VIEW `preguntas-de-negocio.desempeno_canciones.spotify_view` AS
SELECT * 
FROM `preguntas-de-negocio.desempeno_canciones.spotify_clean`;



