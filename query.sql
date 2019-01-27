
/*
							PROGETTO DI LABORATORIO DI BASE DI DATI (SQL)
									Olivero Fabio (833347)
*/

/*
	Query 1:
	Contare il numero di lingue in cui le release contenute nel database sono scritte (il risultato deve contenere
	soltanto il numero delle lingue, rinominato “Numero_Lingue”).

	1) Nello schema si accede alle tabelle language e release
	2) La chiave esterna 'language' di tabella è collegata alla chiave primaria di language
	3) Per prima cosa si seleziona l'elenco di tutte le lingue delle release, con il loro nome, con la seguente query:
			select l.name
			from release r join language l on (r.language = l.id)
	4) Si eliminano le ripetizioni delle lingue uguali aggiungendo 'distinct' alla selezione
	5) --
	6) Il risultato è stato controllato contando i nomi di tutte le lingue senza ripetizioni con la seguente query:
			select distinct language.name
			from release join language on (release.language = language.id)
			
*/

select count (distinct l.name) as Numero_Lingue
from release r join language l on (r.language = l.id)


/* 
    Query 2:
    Elencare gli artisti che hanno cantato canzoni in italiano (il risultato deve contenere il nome dell’artista e il nome della lingua)

    1) Si accede alle tabelle 'artist', 'release' e 'language'
    2) La chiave esterna 'language' di 'release' è riferita alla chiave primaria di language.
    3) La query è stata scritta direttamente abbinando gli artisti con le loro release e l'id della lingua con la tabella lingua
       attraverso cui otteniamo il nome
	4) Non è stata fatta alcuna assunzione sui dati
    5) --
    6) La query è stata verificata associando tutte le release alla propria lingua stampando le lingue con il parametro distinct per 
	   visualizzare una sola volta la lingua:

        select distinct l.name Lingua
        from artist a join release r on a.id = r.artist_credit join language l on r.language = l.id
        order by Lingua;    
*/

select a.name Artista, l.name Lingua
from artist a join release r on a.id = r.artist_credit join language l on r.language = l.id
where l.name = 'Italian';


/*
	Query 3:
	Elencare le release di cui non si conosce la lingua (il risultato deve contenere soltanto il nome della release).

	1) Nello schema si accede alla tabella release
	2) In particolare si controlla il valore della chiave esterna language
	3) La query è stata scritta direttamente selezionando il nome delle release che presentano un campo language nullo
	4) Si verifica che esistano valori nulli del campo language, con la query riportata al punto 6
	5) --
	6) Per verificare che i valori selezionati siano effetivamente nulli si seleziona anche il campo language della release
			select name, language
			from release
			where language is NULL 
*/

select name
from release
where language is NULL 


/*
    Query 4:
    Elencare gli artisti il cui nome contiene tutte le vocali ed è composto da una sola parola (il risultato deve contenere soltanto il nome 
	dell’artista).

    1) Si accede alla tabella 'artist'
    2) Si accede esclusivamente all'attributo 'name'
    3) La query è stata scritta direttamente selezionando i nomi degli artisti 
	4) Non è stata fatta alcuna assunzione sui dati
    5) --
    6) Per il controllo si possono stampare semplicemente i nomi composti da una sola parola e controllare visivamente eventuali nomi con 
	   tutte le vocali con la seguente query:
        
        select a.name Nome
        from artist a
        where a.name NOT LIKE '% %';
*/

select a.name Nome
from artist a
where a.name LIKE '%a%' and
	  a.name LIKE '%e%' and
	  a.name LIKE '%i%' and
	  a.name LIKE '%o%' and
	  a.name LIKE '%u%' and
	  a.name NOT LIKE '% %';


/*
	Query 5:
	Elencare tutti gli pseudonimi di Prince con il loro tipo, se disponibile (il risultato deve contenere lo pseudonimo
	dell'artista, il nome dell’artista (cioè Prince) e il tipo di pseudonimo (se disponibile)).

	1) Nello schema si accede alle tabelle artist e artist_alias contenti le informazioni sugli artisti e sui loro pseudonimi
	2) In particolare viene ricercato l'artista Prince accedendo al campo 'name' di 'artist' e poi attraverso la chiave esterna
	   'artist' di 'artist_alias' e la chiave primaria di 'artist' si accede alle informazioni relative agli pseudonimi di Prince
	3) La query è stata scritta direttamente selezionando gli alias dell'artista corrispondendi all'id dell'artista Prince
	4) Non è stata fatta alcuna assunzione sui dati
	5) --
	6) Per verificare che gli pseudonimi appartengano effettivamente all'artista Prince si seleziona anche l'id dell'artista,
		 il nome dell'artista e la chiave esterna 'artist' di 'alias'
			select artist_alias.name, artist_alias.artist, artist.id, artist.name
			from artist_alias a_a join artist ar on (a_a.artist = ar.id)
			where ar.name = 'Prince'
*/
		
select a_a.name
from artist_alias a_a join artist ar on (a_a.artist = ar.id)
where ar.name = 'Prince'


/*
    Query 6:
    Elencare le release di gruppi inglesi ancora in attività (il risultato deve contenere il nome del gruppo e il nome della release e 
	essere ordinato per nome del gruppo e nome della release)

    1) Si accede alle tabelle 'artist', 'release_group' e 'area'
    2) Troviamo la chiave prima 'id' di 'artist' associata all chiave secondaria 'artist_credit' di 'release group' 
	   e la chiave primaria 'id' di 'area'
    3) La query è stata scritta direttamente abbinando gli artisti alle release group e alla loro nazione
    4) Si verifica se la data di fine carriera è nulla
    5) --
    6) Per il controllo si possono stampare tutte le associazioni di gruppi d'artisti con la loro nazionalità e verificare visivamente 
	queli sono ancora in attività controllando anno, mese e giorno di terminazione se presente, ordinati per nazionalità con la seguente query:
        
        select a2.name Nazionalita, a.name Gruppo, r.name Release_, a.end_date_year Anno_Fine, a.end_date_month Mese_Fine, a.end_date_day Giorno_Fine
        from artist a join release_group r on r.artist_credit = a.id join area a2 on a.area = a2.id
        order by Nazionalita;
 */

select a.name Gruppo, r.name Release_
from artist a join release_group r on r.artist_credit = a.id join area a2 on a.area = a2.id
where a2.name = 'United Kingdom'
	  and a.end_date_year is null
	  and a.end_date_month is null
	  and a.end_date_day is null
order by Gruppo, Release_;

	  
/*
	Query 7:
	Trovare le release in cui il nome dell’artista è diverso dal nome accreditato nella release (il risultato deve
	contenere il nome della release, il nome dell’artista accreditato (cioè artist_credit.name) e il nome dell’artista
	(cioè artist.name))

	1) Nello schema si accede alle tabelle artist_credit, artist e release, che contengono le informazioni sulle release e 
	   sugli artisti accreditati alle release
	2) In particolare si selezionano i campi 'name' di 'artist', 'artist_credit' e 'release' e si confrontano le chiavi
	   primarie di 'artist' e di 'artist_credit' e il campo 'artist_credit' con la chiave primaria di 'artist'
	3) Come primo sottoproblema si selezionano tutti gli artisti accreditati che presentano un nome diverso da quello
		 dell'artista, confrontando il loro id e il loro campo 'name' con la seguente query:
			select a_c.name, ar.name
			from artist ar join artist_credit a_c on (a_c.id = ar.id)
			where a_c.name <> ar.name  
	4) Si eliminano i casi in cui lo stesso artista ha più release con distinct
	5) --
	6) Si può verificare che la selezione ottenuta dalla query riportata sotto è un sottoinsieme della tabella prodotta
	   dalla query del punto 3, quindi si può dedurre che il dato prodotto sia corretto
*/

select distinct r.name, a_c.name, ar.name
from release r join artist ar on (r.artist_credit = ar.id) join artist_credit a_c on (a_c.id = ar.id)
where a_c.name <> ar.name 


/*
    Query 8:
    Trovare gli artisti con meno di tre release (il risultato deve contenere il nome dell’artista ed il numero di release)

    1) Si accede alle Tabelle 'artist' e 'release'
    2) In particolare, la chiave secondaria 'artist_credit' di 'release' è associata alla chiave primaria 'id' di 'artist'
    3) La query è stata scritta direttamente abbinando gli autori alle loro release
	4) Non è stata fatta alcuna assunzione sui dati 
    5) --
    6) Per la verifica si possono stampare i nomi degli artisti associati a ogni propria release e verificare visivamente il numero di 
	   release per ogni artista con la seguente release:
       
        select a.name Artista, r.name
        from artist a join release r on r.artist_credit = a.id
        order by Artista;
*/

select a.name Artista, count(artist_credit) numero_release
from artist a join release r on r.artist_credit = a.id
group by Artista
having count(artist_credit) < 3


/*
	Query 9:
	Trovare la registrazione più lunga di un’artista donna (il risultato deve contenere il nome della registrazione, la
	sua durata in minuti e il nome dell’artista; tenere conto che le durate sono memorizzate in millesimi di secondo)
	(scrivere due versioni della query con e senza operatore aggregato MAX).

	1) Nello schema si accede alle tabelle recording, artist e gender che contengono le informazioni sugli artisti, sul
	   loro genere e sulle registrazioni
	2) In particolare si seleziona il campo length della registrazione più lunga, associato al nome della registrazione
	   e dell'artista. Per trovare le informazioni relative al genere dell'artista si confronta la chiave esterna di recording
		 'artist_credit' con la chiave di artista e poi la chiave esterna 'gender' di artista con la chiave di gender
	3) Come primo sottoproblema è necessario creare una query che trovi la lunghezza della registrazione più lunga di
	   un'artista donna:
			select MAX(r.length) 
			from recording r join artist ar on (r.artist_credit = ar.id) join gender ge on (ar.gender = ge.id) 
			where ge.name='Female'
	4) Si eliminano i casi in cui si ripete la stessa registrazione con distinct
	5) Seconda versione riportata al di sotto della prima
	6) Si può verificare il risultato ottenuto andando a ricercare il nome corrispondente alla registrazione che ha una
	   durata pari a quella indicata dalla query al punto 3
			select artist_credit.name
			from recording, artist_credit
			where artist_credit.id=recording.artist_credit and recording.length='702546'
*/

select distinct r.name, r.length/1000/60, ar.name
from recording r join artist ar on (r.artist_credit = ar.id)
where r.length = (select MAX(r.length) 
				  from recording r join artist ar on (r.artist_credit = ar.id) join gender ge on (ar.gender = ge.id) 
				  where ge.name='Female')
	  
--Seconda versione: il 'select MAX' è stato sostituito da una differenza insiemistica
select distinct r.name, r.length/1000/60, ar.name
from recording r join artist ar on (r.artist_credit = ar.id)
where r.length= (select distinct r.length
				from recording r join artist ar on (r.artist_credit = ar.id) join gender ge on (ar.gender = ge.id)
				where ge.name = 'Female' and r.length is not null
					except
				select distinct rec1.length
				from recording rec1, recording rec2, artist art1, artist art2, gender
				where rec1.length<rec2.length and
					  rec1.artist_credit = art1.id and
					  rec2.artist_credit = art2.id and
					  art1.gender = gender.id and
					  art2.gender = gender.id and
					  gender.name = 'Female')
	
/*
    Query 10:
    Elencare le lingue cui non corrisponde nessuna release (il risultato deve contenere il nome della lingua, il numero di release in quella 
	lingua, cioè 0, e essere ordinato per lingua) (scrivere due versioni della query).

    1) Si accede alle tabelle 'language' e 'release' nella prima versione
    2) Troviamo la chiave secondaria 'language' di 'release', la chiave primaria 'id' di 'language'
    3) Nella prima versione la query più interna seleziona tutte le release in cui è specificata la lingua:
 
          select l.name Lingua
          from release r join language l on r.language = l.id
          where r.language is not null
    
    4) Selezioniamo nella query più interna le release per cui la lingua sia diversa da null
	5) Seconda versione riportata al di sotto della prima
    6) Per la verifica si possono associare ad ogni release la proria lingua e raggruppare tutte le release sulla stessa lingua, 
	   verificando visivamente la presenza di lingue con valori nulli con la seguente query
        
        select l.name Lingua, r.language release_
        from language l left join release r on r.language = l.id
        group by Lingua, r.language
        order by release_;
*/

select l.name Lingua, (count(r.language))
from language l, release r
where l.name not in(
				  select l.name Lingua
				  from release r join language l on r.language = l.id
				  where r.language is not null)
and r.language is null
group by Lingua, r.language
order by Lingua;

--Seconda versione:
select l.name Lingua, count(r.language) 
from language l left join release r on r.language = l.id
where r.language is null
group by Lingua, r.language
order by Lingua	
	
	
/*					  
	Query 11:
	Ricavare la seconda registrazione per lunghezza di un artista uomo (il risultato deve comprendere l'artista
	accreditato, il nome della registrazione e la sua lunghezza) (scrivere due versioni della query). 

	1) Nello schema si accede alle tabelle recording, artist e gender
	2) In particolare si seleziona il campo length della seconda registrazione più lunga, associato al nome della registrazione
	   e dell'artista. Per trovare le informazioni relative al genere dell'artista si confronta la chiave esterna di recording
		 'artist_credit' con la chiave di artista e poi la chiave esterna 'gender' di artista con la chiave di gender.
	3) Come primo sottoproblema è necessario creare una query che trovi la lunghezza della registrazione più lunga di
	   un artista uomo, escludendo la più lunga:
			select MAX (r.length)
				  from recording r join artist ar on (r.artist_credit = ar.id) join gender ge on (ar.gender = ge.id)
				  where r.length <> (select MAX(r.length) 
									 from recording r join artist ar on (r.artist_credit = ar.id) join gender ge on (ar.gender = ge.id)
									 where ge.name='Male') 
	4) Si eliminano i casi in cui si ripete la stessa registrazione con distinct
	5) Seconda versione riportata al di sotto della prima
	6) Si può verificare il risultato ottenuto andando a ricercare il nome corrispondente alla registrazione che ha una
	   durata pari a quella indicata dalla query al punto 3
			select artist_credit.name
			from recording join artist_credit on artist_credit.id=recording.artist_credit
			where recording.length='2171360'
*/

select distinct r.name, r.length/1000/60, ar.name
from recording r join artist ar on (r.artist_credit = ar.id)
where r.length = (select MAX (r.length)
				  from recording r join artist ar on (r.artist_credit = ar.id) join gender ge on (ar.gender = ge.id)
				  where r.length <> (select MAX(r.length) 
									 from recording r join artist ar on (r.artist_credit = ar.id) join gender ge on (ar.gender = ge.id)
									 where ge.name='Male')
					and ge.name='Male')			
	  
--Seconda versione: il secondo 'select MAX' è stato sostituito con una differenza insiemistica	  
select distinct r.name, r.length/1000/60, ar.name
from recording r join artist ar on (r.artist_credit = ar.id)
where r.length = (select MAX (r.length)
						  from recording r join artist ar on (r.artist_credit = ar.id) join gender ge on (ar.gender = ge.id)
						  where r.length <> (select distinct r.length
													from recording r join artist ar on (r.artist_credit = ar.id) join gender ge on (ar.gender = ge.id)
													where ge.name = 'Male' and r.length is not null
														except
													select distinct rec1.length
													from recording rec1 join recording rec2 on (rec1.length<rec2.length) join artist art1 on
														(rec1.artist_credit = art1.id) join artist art2 on (rec2.artist_credit = art2.id)
														join gender ge on (art1.gender = ge.id and art2.gender = ge.id)
													where ge.name = 'Male')
						  and ge.name='Male')


/*
    Query 12:
    Per ogni stato esistente riportare la lunghezza totale delle registrazioni di artisti di quello stato (il risultato deve
    comprendere il nome dello stato e la lunghezza totale in minuti delle registrazioni (0 se lo stato non ha
    registrazioni) (scrivere due versioni della query)

    1) Si accede alle tabelle 'area', 'artist' e 'recording'
    2) La chiave primaria 'id' di 'area' è associata  alla chiave secondaria 'area' di 'artisti' e la chaive primaria 'id' di 'artist'
	   è associata alla chiave secondaria 'artist_credit' di 'recording'
    3) Nella seconda versione si associa ogni artista con le proprie canzoni registrate per avere il tempo totale raccogliendo su Artista
        
        select r.artist_credit Artista, sum(r.length)
        from artist a join recording r on a.id = r.artist_credit
        group by Artista
        order by Artista

	4) Non è stata fatta alcuna assunzione sui dati 
	5) Seconda versione riportata al di sotto della prima
    6) Per la verifica si possono associare gli artisti associati alla loro nazionalità con la rispettiva lunghezza e verificare 
	   visivamente la somma per tutti gli artisti di uno stato:
        
		select a.name Stato, a2.name , (r.length)/1000/60 Tempo
		from (area a left join artist a2 on a.id = a2.area) left join recording r on r.artist_credit = a2.id
		order by Stato;
*/

select a.name Stato, case when sum(r.length) is null then '0' else sum(r.length)/1000/60 end
from (area a left join artist a2 on a.id = a2.area) left join recording r on r.artist_credit = a2.id
group by Stato, a2.area

--Seconda versione:
select a.name Stato, case when sum(r.length) is null then '0' else sum(r.length)/1000/60 end
from (area a left join artist a2 on a.id = a2.area) left join recording r on r.artist_credit = a2.id
where exists (
			select r.artist_credit Artista, sum(r.length)
			from artist a join recording r on a.id = r.artist_credit
			group by Artista)
group by Stato, a2.area    

	  
/*	  
	Query 13:
	Ricavare gli artisti britannici che hanno pubblicato almeno 10 release (il risultato deve contenere il nome
	dell’artista, il nome dello stato (cioè United Kingdom) e il numero di release) (scrivere due versioni della query).

	1) Nello schema si accede alle tabelle release, artist e area
	2) In particolare si seleziona il nome della nazione dell'artista, il suo nome e il numero di pubblicazioni che fa fatto.
	   Per contare il numero di release di un artista si confronta la chiave esterna 'artist_credit' di release con la chiave
	   di artist. Inoltre si confronta la chiave esterna 'area' di artist con la chiave di 'area'.
	3) Come primo sottoproblema è necessario scrivere una query che permetta di elencare il nome di un artista per ogni sua
	   release con la seguente query:
			select ar.name, area.name, count(*)
			from release r join artist ar on (r.artist_credit = ar.id) join area on (ar.area = area.id)
			where area.name = 'United Kingdom'
	4) Non è stata fatta alcuna assunzione sui dati
	5) Seconda versione riportata al di sotto della prima
	6) Il risultato si può controllare attraverso l'output della query riportata al punto 3, in cui gli artisti che compaiono
		 nella tabella finale devono essere elencati più di 10 volte
*/

select ar.name, area.name, count(*)
from release r join artist ar on (r.artist_credit = ar.id) join area on (ar.area = area.id)
where area.name = 'United Kingdom'
group by ar.name, area.name
having count(*)>10

--Seconda versione: ottenuta sfruttando al differenza insiemistica
select ar.name, area.name, count(*)
from release r join artist ar on (r.artist_credit = ar.id) join area on (ar.area = area.id)
where area.name = 'United Kingdom'
group by ar.name, area.name
	except
select ar.name, area.name, count(*)
from release r join artist ar on (r.artist_credit = ar.id) join area on (ar.area = area.id)
where area.name = 'United Kingdom'
group by ar.name, area.name
having count(*)<=10

/*
    Query 14:
    Considerando il numero medio di tracce tra le release pubblicate su CD, ricavare gli artisti che hanno pubblicato
    esclusivamente release con più tracce della media (il risultato deve contenere il nome dell’artista e il numero di
    release ed essere ordinato per numero di release discendente) (scrivere due versioni della query)

    1) Si accede alle tabelle 'track', 'medium', 'release', 'release_packaging' e 'artist'
    2) La chiave secondaria 'medium' di 'track' è associata alla chiave primaria 'id' di 'medium', la chiave secondaria 'release' 
	di 'medium' è associata alla chiave primaria 'id' di 'release, la chiave secondaria 'packaging' di 'release' è associata alla 
	chiave primaria 'id' di 'release_packaging e la chiave secondaria 'artist_credit' di 'release' è associata alla chiave primaria 
	'id' di 'artist' 
    3) nella prima versione il sottoproblema più interno conta il numero di release pubblicate su CD:
            
            select count (ar.name)
		    from artist ar join release r on (ar.id=r.artist_credit) join release_packaging rp on (r.packaging = rp.id)
		    where rp.name = 'Jewel Case'

       mentre il secondo sottoprobelma conta il numero di artisti con canzoni su CD:

            select  count(*)
	        from track t join medium m on (t.medium = m.id) join release r on (m.release = r.id) join release_packaging rp on 
				(r.packaging = rp.id) join artist ar on (ar.id=r.artist_credit)
	        where rp.name = 'Jewel Case')
      
       nella seconda versione abbiamo le prime due sotto query in cui si calcola il numero totale di release meno le release che 
	   non sono registrate su CD: 

            (select count (ar.name)
    	     from artist ar join release r on (ar.id=r.artist_credit) join release_packaging rp on (r.packaging = rp.id)) - 
                (select count (ar.name)
                 from artist ar join release r on (ar.id=r.artist_credit) join release_packaging rp on (r.packaging = rp.id)
                 where rp.name NOT LIKE 'Jewel Case' ))
 
     (la restante parte è uguale alla precedente)

	4) Non è stata fatta alcuna assunzione sui dati
	5) Seconda versione riportata al di sotto della prima
    6) Per la verifica possiamo dividere la seguemte query in piu pezzi, il rapporto tra artisti su cd e canzoni su cd ci fornisce 
	   la media desidereata
    
            select count (ar.name) --canzoni su cd
		    from artist ar join release r on (ar.id=r.artist_credit) join release_packaging rp on (r.packaging = rp.id)
		    where rp.name = 'Jewel Case';

            select  count(*) --artisti su cd
	        from track t join medium m on (t.medium = m.id) join release r on (m.release = r.id) join release_packaging rp 
				on (r.packaging = rp.id) join artist ar on (ar.id=r.artist_credit)
	        where rp.name = 'Jewel Case';
 
       Questa ultima query fornisce il numero di canzoni per artista su cd, in questo modo si possono verificare visivamente 
	   gli artisti con un numero di canzoni minore della media di canzoni su cd:
       
            select   ar.name, count(*) canzoni
            from track t join medium m on (t.medium = m.id) join release r on (m.release = r.id) join release_packaging rp 
				on (r.packaging = rp.id) join artist ar on (ar.id=r.artist_credit)
            where rp.name = 'Jewel Case'
            group by r.id, ar.id
            order by canzoni;
    */

select  count(*), ar.name
from track t join medium m on (t.medium = m.id) join release r on (m.release = r.id) join release_packaging rp 
	on (r.packaging = rp.id) join artist ar on (ar.id=r.artist_credit)
where rp.name = 'Jewel Case'
group by r.id, ar.id
having count(*)> 
	((select  count(*)
	from track t join medium m on (t.medium = m.id) join release r on (m.release = r.id) join release_packaging rp 
		on (r.packaging = rp.id) join artist ar on (ar.id=r.artist_credit)
	where rp.name = 'Jewel Case') / 
		(select count (ar.name)
		from artist ar join release r on (ar.id=r.artist_credit) join release_packaging rp on (r.packaging = rp.id)
		where rp.name = 'Jewel Case'))
order by count

--Seconda versione: ottenuta tramite una differenza tra i conteggi
select  count(*), ar.name
from track t join medium m on (t.medium = m.id) join release r on (m.release = r.id) join release_packaging rp 
	on (r.packaging = rp.id) join artist ar on (ar.id=r.artist_credit)
where rp.name = 'Jewel Case'
group by r.id, ar.id
having count(*)>
	((select  count(*)
	from track t join medium m on (t.medium = m.id) join release r on (m.release = r.id) join release_packaging rp 
		on (r.packaging = rp.id) join artist ar on (ar.id=r.artist_credit)
	where rp.name = 'Jewel Case') /
   ((select count (ar.name)
	 from artist ar join release r on (ar.id=r.artist_credit) join release_packaging rp on (r.packaging = rp.id)) - 
		(select count (ar.name)
		 from artist ar join release r on (ar.id=r.artist_credit) join release_packaging rp on (r.packaging = rp.id)
		 where rp.name NOT LIKE 'Jewel Case' )))
order by count

/*
	Query 15:
	Ricavare il primo artista morto dopo Louis Armstrong (il risultato deve contenere il nome dell’artista, la sua data
	di nascita e la sua data di morte) (scrivere due versioni della query).

	1) Nello schema si accede solamente alla tabella artist, che contiene tutte le informazioni su data di nascita e morte
	2) In particolare giorno, mese e anno di morte di ogni artisti vengono confrontati con la data di morte di Armstrong
	3) La query è stata scritta unendo 3 sottoproblemi, per trovare il giorno, il mese e l'anno della prima data di morte
	   successiva a quella di Armstrong:
	   
			select min(artist.end_date_year) --anno
			from artist
			where artist.end_date_year>='1971' 
			and artist.end_date_month>='7' 
			and artist.end_date_day>'6'
			
			select min(artist.end_date_month) --mese
			from artist
			where   artist.end_date_month>='7' 
					and artist.end_date_day>'6'
					and artist.end_date_year =( 
						select min(artist.end_date_year)
						from artist
						where artist.end_date_year>='1971' 
						and artist.end_date_month>='7' 
						and artist.end_date_day>'6')
						
			select min(artist.end_date_day) --giorno
			from artist
			where artist.end_date_day>'6'
			and artist.end_date_month = (
				select min(artist.end_date_month)
				from artist
				where   artist.end_date_month>='7' 
						and artist.end_date_day>'6'
						and artist.end_date_year =( 
							select min(artist.end_date_year)
							from artist
							where artist.end_date_year>='1971' 
							and artist.end_date_month>='7' 
							and artist.end_date_day>'6'))
			
	4) Le query sono strutturate conoscendo a priori la data di morte di Armstrong, dato al quale si accede con la seguente query:
			select artist.end_date_year, artist.end_date_month, artist.end_date_day
			from artist 
			where artist.name = 'Louis Armstrong'
	5) Seconda versione riportata al di sotto della prima
	6) Il risultato si può verificare stampando le date di morte di tutti gli artisti dal 1971 in avanti in ordine e controllando
	   che la data successiva a quella di Armstrong sia quella ripostata dalla query, attraverso la seguente query:
			select artist.end_date_year, artist.end_date_month, artist.end_date_day
			from artist 
			where artist.end_date_year>='1971'
			order by artist.end_date_year asc
*/

select artist.begin_date_year, artist.begin_date_month, artist.begin_date_day, 
	   artist.end_date_year, artist.end_date_month, artist.end_date_day, artist.name
from artist
where artist.end_date_day = ( --giorno
	select min(artist.end_date_day)
	from artist
	where artist.end_date_day>'6'
	and artist.end_date_month = (
		select min(artist.end_date_month)
		from artist
		where   artist.end_date_month>='7' 
				and artist.end_date_day>'6'
				and artist.end_date_year =( 
					select min(artist.end_date_year)
					from artist
					where artist.end_date_year>='1971' 
					and artist.end_date_month>='7' 
					and artist.end_date_day>'6'))
		and artist.end_date_year =( 
			select min(artist.end_date_year)
			from artist
			where artist.end_date_year>='1971' 
			and artist.end_date_month>='7' 
			and artist.end_date_day>'6'))
	and artist.end_date_month = ( --mese
		select min(artist.end_date_month)
		from artist
		where   artist.end_date_month>='7' 
				and artist.end_date_day>'6'
				and artist.end_date_year =( 
					select min(artist.end_date_year)
					from artist
					where artist.end_date_year>='1971' 
					and artist.end_date_month>='7' 
					and artist.end_date_day>'6'))
	and artist.end_date_year = ( --anno
		select min(artist.end_date_year)
		from artist
		where artist.end_date_year>='1971' 
		and artist.end_date_month>='7' 
		and artist.end_date_day>'6')
			
			
--Seconda versione: uso della concatenazione e del cofronto tra stringhe al posto dei 'select MIN'
select artist.begin_date_year, artist.begin_date_month, artist.begin_date_day, 
	   artist.end_date_year, artist.end_date_month, artist.end_date_day, artist.name
from artist 
where (artist.end_date_year || ' ' || artist.end_date_month || ' ' ||artist.end_date_day) = 
	(select min(artist.end_date_year || ' ' || artist.end_date_month || ' ' ||artist.end_date_day)
	from artist
	where (artist.end_date_year || ' ' || artist.end_date_month || ' ' ||artist.end_date_day) > '1971 7 6')
	
	
/*
    Query 16:
    Elencare le coppie di etichette discografiche che non hanno mai fatto uscire una release in comune ma hanno fatto
    uscire una release in collaborazione con una medesima terza etichetta (il risultato deve comprendere i nomi delle
    coppie di etichette discografiche) (scrivere due versioni della query)

    1) Nello si accede alle tabelle release e release_label
    2) In particolare vengono confrontati i campi label e release label delle stesse tabelle e il campo label di 
	   release_label con la chiave di label
    3) Il primo sotto problema che si pone è quello per trovare le coppie di etichette che hanno collaborato almeno
	   una volta, attraverso la seguente query:
		  select distinct l1.label, l2.label
		  from release_label l1 join release_label l2 on (l1.label <> l2.label and l1.release = l2.release)
    4) Nella selezione si eliminano le ripetizioni con il distinct causate dai 3 join presenti nella query più esterna
	5) Seconda versione riportata al di sotto della prima
    6) Per controllare i dati ottenuti si può scegliere di visualizzare anche gli ID di tutte le release della tupla selezionata
	   e le etichette delle ultime due. In questo modo se sono uguali le release 1 e 3, le release 2 e 4 e le label 3 e 4 significa
	   che le label 1 e 2 non hanno mai collaborato (condizione garantita dal 'not in'), ma hanno collaborato con una terza etichetta
	   comune
	   
	    select distinct la1.name, la2.name, l1.release, l2.release, l3.release, l4.release, l3.label, l4.label
		from release_label l1 join release_label l2 on (l1.label <> l2.label and l1.release <> l2.release) join release_label l3 
			on (l1.release = l3.release) join release_label l4 on (l2.release = l4.release) join label la1 on (l1.label=la1.id)
			join label la2 on (l2.label=la2.id)
		where l3.label = l4.label and
			  (l1.label, l2.label) not in (select distinct l1.label, l2.label
										  from release_label l1 join release_label l2 on 
											  (l1.label <> l2.label and l1.release = l2.release))

*/

select distinct la1.name, la2.name
from release_label l1 join release_label l2 on (l1.label <> l2.label and l1.release <> l2.release) join release_label l3 
	on (l1.release = l3.release) join release_label l4 on (l2.release = l4.release) join label la1 on (l1.label=la1.id)
	join label la2 on (l2.label=la2.id)
where l3.label = l4.label and
	  (l1.label, l2.label) not in (select distinct l1.label, l2.label
								  from release_label l1 join release_label l2 on (l1.label <> l2.label and l1.release = l2.release))
								  
--Seconda versione: ottenuta attraverso la differenza insiemistica
select distinct la1.name, la2.name
from release_label l1 join release_label l2 on (l1.label <> l2.label and l1.release <> l2.release) join release_label l3 
	on (l1.release = l3.release) join release_label l4 on (l2.release = l4.release) join label la1 on (l1.label=la1.id)
	join label la2 on (l2.label=la2.id)
where l3.label = l4.label
	except
(select distinct la1.name, la2.name
from release_label l1 join release_label l2 on (l1.label <> l2.label and l1.release = l2.release) join
 label la1 on (l1.label = la1.id) join label la2 on (l2.label = la2.id))
