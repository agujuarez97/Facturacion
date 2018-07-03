drop schema if  exists "facturacion" cascade;
create schema "facturacion";
set search_path = "facturacion";

/*Creacion de dominio el cual permite saber cual es el tipo de documento*/
create domain TipoDoc as varchar(4) 
default 'DNI'
check (
	value in ('DNI','CUIT','CUIL') 
);

/*Creacion de dominio el cual permite saber cual es el tipo de iva*/
create domain TipoIva as varchar(50) 
default 'CONSUMIDOR FINAL'
check (
	value in ('CONSUMIDOR FINAL','RESPONSABLE INSCRIPTO','RESPONSABLE MONOTRIBUTO','SUJETO EXENTO') 
);

/*Creacion de dominio el cual permite saber cual es el estado de un cliente o articulo*/
create domain TipoEstado as varchar(30) 
default 'HABILITADO'
check (
	value in ('HABILITADO','SUSPENDIDO','CANCELADO') 
);

/*Creacion de dominio el cual permite saber cual es el iva*/
create domain TipoCantIva as varchar(30)
default '0'
check (
	value in ('0', '10.5' , '21' , '27') 
);

/*Creacion de dominio el cual permite saber como sera la venta*/
create domain TipoVenta as varchar(20)
default 'CONTADO'
check (
	value in ('CONTADO', 'CUENTA CORRIENTE') 
);

/*Creacion de dominio el cual permite saber de que tipo va a ser el movimiento de stock*/
create domain TipoMovi as varchar(15)
default 'INGRESO'
check (
	value in ('INGRESO', 'EGRESO')
);

/*Creacion de tabla la cual permite guardar la informacion de un usuario*/
create table conf_usuario (
	login varchar(20) not null,
	pas varchar(20),
	cod_usuario serial not null,
	nombre varchar(40),
	constraint pkUsuario primary key (cod_usuario)
);

/*Creacion de tabla la cual permite guardad la localidad con su codigo postal*/
create table Localidades (
	cod_postal integer not null,
	nombre varchar(150),
	constraint pkLocalidades primary key (cod_postal)
);

/*Creacion de tabla la cual permite guardar la informacion de un cleinte*/
create table ven_cliente (
	cod_cliente serial,
	razon_social varchar(50) not null,
	nom_comercial varchar(50),
	tipo_dni TipoDoc,
	num_dni varchar(11) not null,
	cat_iva TipoIva,
	ing_brutos varchar(11),
	direccion varchar(50),
	codigo_postal integer,
	localidad varchar(100),
	tel_fijo varchar(20),
	celular varchar(20),
	mail varchar(50),
	cond_venta TipoVenta,
	morosidad integer check (morosidad >= 0),
	limite_credito real check (limite_credito >= 0),
	estado TipoEstado,
	constraint pkCliente primary key (cod_cliente),
	constraint fkLocalidad foreign key (codigo_postal) references Localidades(cod_postal)
);
/*Creacion de tabla la cual permite guardar en la CC de cada cliente el monto adeudado*/
create table ven_cc (
	cod_cliente integer not null,
	monto_total real,
	constraint pkVenCC primary key (cod_cliente),
	constraint fkVenCC foreign key (cod_cliente) references ven_cliente (cod_cliente)
);

/*Creacion de tabla la cual permite registrar los pagos parciales de cada cliente en su CC*/
create table ven_pagoparcialCC (
	cod_cliente integer not null,
	fecha date not null,
	nto_parcial real,
	constraint pkPagoParcial primary key (cod_cliente),
	constraint fkPagoParcial foreign key (cod_cliente) references ven_cliente(cod_cliente)
);

/*Creacion de tabla la cual permite guardar la informacion de un articulo*/
create table Articulo (
	cod_articulo varchar(20) not null,
	EAN varchar(20) not null,
	nombre varchar(40) not null,
	descripsion varchar(100),
	precio_compra real check (precio_compra >= 0) default 0,
	margen real check (margen >= 0) default 0,
	precio_venta real check (precio_venta >= 0) default 0,
	iva TipoCantIva,
	precio_final real check (precio_final >= 0) default 0,
	stock integer default 0,
	stock_minimo integer check (stock_minimo >= 0) default 0,
	stock_maximo integer check (stock_maximo >= stock_minimo) default 0,
	estado TipoEstado,
	constraint pkArticulo primary key(cod_articulo)
);

/*Creacion de tabla la cual permite guardar los datos del movimiento de stock*/
create table movimiento_cabecera (
	cod_movimiento serial not null,
	fecha date,
	descripcion varchar(100),
	constraint pkMovCabecera primary key (cod_movimiento)
);

/*Creacion de tabla la cual permite guardar movimientos*/

create table movimiento_renglon (
	cod_articulo varchar(20) not null,
	cod_movimiento serial not null, /* WARNING: cambiar cod_movimiento al primero lugar*/
	cantidad integer,
	tipo TipoMovi,
	constraint pkMovRenglon primary key (cod_articulo, cod_movimiento),
	constraint fkArticuloMov foreign key (cod_articulo) references Articulo (cod_articulo),
	constraint fkMovCabe foreign key (cod_movimiento) references movimiento_cabecera (cod_movimiento)
);

create table movimiento_actual (
    cod_articulo varchar(20) not null,
    cantidad integer,
    tipo TipoMovi,
    constraint pkMovActual primary key (cod_articulo),
    constraint fkArticuloMovActual foreign key (cod_articulo) references Articulo (cod_articulo)
);

/*Creacion de tabla la cual permite guardar toda la informacion de la empresa*/
create table Empresa (
	razon_social varchar(100) not null,
	nombre_fantasia varchar(100),
	cat_iva TipoIva,
	tipo_dni TipoDoc not null,
	num_dni varchar(11) not null,
	ing_brutos varchar(15),
	inicion_activ varchar(10) not null,
	direccion varchar(100) not null,
	codigo_postal integer not null,
	localidad varchar(100),
	telefono varchar(15),
	mail varchar(50),
	pag_web varchar(50),
	constraint pkEmpresa primary key (razon_social),
	constraint fkLocalidad foreign key (codigo_postal) references Localidades (cod_postal)
);

/*Creacion de tabla la cual permite guardar la informacion de la cabecera de la factura*/
create table ven_cabecera (
	cod_venta serial not null,
	cod_facturacion integer not null, 
	punto_venta integer not null,
	letra varchar(1),
	fecha_facturacion date not null,
	fecha_vto date not null check (fecha_vto >= fecha_facturacion),
	condicion_venta TipoVenta,
	subtotal real not null check (subtotal >= 0),
	descuento real default 0,
	neto real,
	iva real,
	total integer not null,
	cod_cliente integer,
	cod_usuario serial,
	razon_social varchar(100),
	constraint pkFacturacion primary key(cod_venta),
	constraint fkUsuario foreign key (cod_usuario) references conf_usuario(cod_usuario),
	constraint fkCliente foreign key (cod_cliente) references ven_cliente(cod_cliente),
	constraint fkEmpresa foreign key (razon_social) references Empresa(razon_social)
);

/*Creacion de tabla la cual permite guardar la informacion de los renglones de la factura*/
create table ven_renglon (
	cod_venta serial not null,
	cod_articulo varchar(20) not null,
	observacion varchar(150),
	cantidad integer check (cantidad > 0) default 1,
	precio_unitario real check (precio_unitario >= 0),
	bonificacion real,
	precio_bonificado real,
	precio_total real,
	constraint pkRenglon primary key (cod_venta, cod_articulo),
	constraint fkCabecera foreign key ( cod_venta) references  ven_cabecera(cod_venta),
	constraint fkArticulo foreign key (cod_articulo) references Articulo(cod_articulo)
);	
/*insert into conf_usuario (login, pas ) values ('ad','123');
select * from Articulo

INSERT INTO Localidades values (  358 , 'LAS VERTIENTES  - (CBA)');
INSERT INTO Localidades values ( 1658 , 'TROPEZON - (CBA)');
INSERT INTO Localidades values ( 2189 , 'CRUZ ALTA- (CBA)');
INSERT INTO Localidades values ( 2400 , 'SAN FRANCISCO- (CBA)');
INSERT INTO Localidades values ( 2413 , 'FREYRE- (CBA)');
INSERT INTO Localidades values ( 2415 , 'PORTEÑA  - (CBA)');
INSERT INTO Localidades values ( 2417 , 'LA PAQUITA - (CBA)');
INSERT INTO Localidades values ( 2419 , 'BRINKMANN- (CBA)');
INSERT INTO Localidades values ( 2421 , 'MORTEROS - (CBA)');
INSERT INTO Localidades values ( 2424 , 'DEVOTO- (CBA)');
INSERT INTO Localidades values ( 2426 , 'LA FRANCIA - (CBA)');
INSERT INTO Localidades values ( 2432 , 'EL TIO- (CBA)');
INSERT INTO Localidades values ( 2433 , 'VILLA CONCEPCION DEL TIO - (CBA)');
INSERT INTO Localidades values ( 2434 , 'ARROYITO - (CBA)');
INSERT INTO Localidades values ( 2435 , 'LA TORDILLA- (CBA)');
INSERT INTO Localidades values ( 2436 , 'TRANSITO - (CBA)');
INSERT INTO Localidades values ( 2550 , 'BELL VILLE - (CBA)');
INSERT INTO Localidades values ( 2553 , 'JUSTINIANO POSSE- (CBA)');
INSERT INTO Localidades values ( 2555 , 'ORDOÑEZ  - (CBA)');
INSERT INTO Localidades values ( 2557 , 'IDIAZABAL- (CBA)');
INSERT INTO Localidades values ( 2559 , 'CINTRA- (CBA)');
INSERT INTO Localidades values ( 2563 , 'NOETINGER- (CBA)');
INSERT INTO Localidades values ( 2566 , 'SAN MARCOS SUD  - (CBA)');
INSERT INTO Localidades values ( 2568 , 'MORRISON - (CBA)');
INSERT INTO Localidades values ( 2572 , 'BALLESTEROS- (CBA)');
INSERT INTO Localidades values ( 2580 , 'MARCOS JUAREZ- (CBA)');
INSERT INTO Localidades values ( 2581 , 'LOS SURGENTES- (CBA)');
INSERT INTO Localidades values ( 2583 , 'GRAL. BALDISSERA- (CBA)');
INSERT INTO Localidades values ( 2585 , 'CAMILO ALDAO - (CBA)');
INSERT INTO Localidades values ( 2587 , 'INRIVILLE- (CBA)');
INSERT INTO Localidades values ( 2589 , 'MONTE BUEY - (CBA)');
INSERT INTO Localidades values ( 2592 , 'GENERAL ROCA - (CBA)');
INSERT INTO Localidades values ( 2594 , 'LEONES- (CBA)');
INSERT INTO Localidades values ( 2624 , 'ARIAS - (CBA)');
INSERT INTO Localidades values ( 2625 , 'CAVANAGH - (CBA)');
INSERT INTO Localidades values ( 2627 , 'GUATIMOZIN - (CBA)');
INSERT INTO Localidades values ( 2645 , 'CORRAL DE BUSTOS- (CBA)');
INSERT INTO Localidades values ( 2646 , 'COLONIA ITALIANA- (CBA)');
INSERT INTO Localidades values ( 2650 , 'CANALS- (CBA)');
INSERT INTO Localidades values ( 2651 , 'PUEBLO ITALIANO - (CBA)');
INSERT INTO Localidades values ( 2655 , 'WENSESLAO ESCALANTE  - (CBA)');
INSERT INTO Localidades values ( 2657 , 'LABORDE  - (CBA)');
INSERT INTO Localidades values ( 2659 , 'MONTE MAIZ - (CBA)');
INSERT INTO Localidades values ( 2661 , 'ISLA VERDE - (CBA)');
INSERT INTO Localidades values ( 2662 , 'ALEJO LEDESMA- (CBA)');
INSERT INTO Localidades values ( 2664 , 'BENJAMIN GOULD  - (CBA)');
INSERT INTO Localidades values ( 2670 , 'LA CARLOTA - (CBA)');
INSERT INTO Localidades values ( 2671 , 'SANTA EUFEMIA- (CBA)');
INSERT INTO Localidades values ( 2672 , 'VIAMONTE - (CBA)');
INSERT INTO Localidades values ( 2675 , 'CHAZON- (CBA)');
INSERT INTO Localidades values ( 2677 , 'UCACHA- (CBA)');
INSERT INTO Localidades values ( 2679 , 'PASCANAS - (CBA)');
INSERT INTO Localidades values ( 2681 , 'ETRURIA  - (CBA)');
INSERT INTO Localidades values ( 2686 , 'ALEJANDRO ROCA  - (CBA)');
INSERT INTO Localidades values ( 3095 , 'RUTA 19 KM. 49  - (CBA)');
INSERT INTO Localidades values ( 4786 , 'COLON - (CBA)');
INSERT INTO Localidades values ( 5000 , 'CORDOBA  - (CBA)');
INSERT INTO Localidades values ( 5001 , 'BARRIO ALTA CORDOBA  - (CBA)');
INSERT INTO Localidades values ( 5003 , 'BARRIO LAS PALMAS  - (CBA)');
INSERT INTO Localidades values ( 5006 , 'SAN JERONIMO 2691  - (CBA)');
INSERT INTO Localidades values ( 5008 , 'BARRIO POETA LUGONES - (CBA)');
INSERT INTO Localidades values ( 5009 , 'Cerro de las Rosa Cordoba - (CBA)');
INSERT INTO Localidades values ( 5010 , 'BARRIO LOS NARANJOS  - (CBA)');
INSERT INTO Localidades values ( 5011 , 'BARRIO PARQUE CAPITAL  - (CBA)');
INSERT INTO Localidades values ( 5012 , 'RESIDENCIAL  AMERICA - (CBA)');
INSERT INTO Localidades values ( 5013 , 'BARRIO  PUEYRREDON - (CBA)');
INSERT INTO Localidades values ( 5014 , 'BARRIO JARDIN- (CBA)');
INSERT INTO Localidades values ( 5016 , 'BARRIO PARQUE LATINO - (CBA)');
INSERT INTO Localidades values ( 5017 , 'MENDIOLAZA - (CBA)');
INSERT INTO Localidades values ( 5019 , 'GUIÑAZU  - (CBA)');
INSERT INTO Localidades values ( 5020 , 'FERREYRA - (CBA)');
INSERT INTO Localidades values ( 5101 , 'MALAGUEÑO- (CBA)');
INSERT INTO Localidades values ( 5102 , 'YOCSINA  - (CBA)');
INSERT INTO Localidades values ( 5105 , 'VILLA ALLENDE- (CBA)');
INSERT INTO Localidades values ( 5109 , 'UNQUILLO - (CBA)');
INSERT INTO Localidades values ( 5110 , 'MALAGUEÑO- (CBA)');
INSERT INTO Localidades values ( 5111 , 'RIO CEBALLOS - (CBA)');
INSERT INTO Localidades values ( 5113 , 'SALSIPUEDES- (CBA)');
INSERT INTO Localidades values ( 5117 , 'ASCOCHINGA - (CBA)');
INSERT INTO Localidades values ( 5121 , 'DESPEÑADEROS - (CBA)');
INSERT INTO Localidades values ( 5123 , 'FERREYRA - (CBA)');
INSERT INTO Localidades values ( 5125 , 'MONTE CRISTO - (CBA)');
INSERT INTO Localidades values ( 5127 , 'RIO PRIMERO- (CBA)');
INSERT INTO Localidades values ( 5133 , 'SANTA ROSA DE RIO PRIMERO - (CBA)');
INSERT INTO Localidades values ( 5135 , 'DIEGO DE ROJA- (CBA)');
INSERT INTO Localidades values ( 5137 , 'LA PARA  - (CBA)');
INSERT INTO Localidades values ( 5139 , 'MARULL- (CBA)');
INSERT INTO Localidades values ( 5141 , 'BALNEARIA- (CBA)');
INSERT INTO Localidades values ( 5143 , 'MIRAMAR  - (CBA)');
INSERT INTO Localidades values ( 5145 , 'GUIÑAZU  - (CBA)');
INSERT INTO Localidades values ( 5147 , 'VILLA GENERAL BELGRANO - (CBA)');
INSERT INTO Localidades values ( 5148 , 'VILLA BELGRANO  - (CBA)');
INSERT INTO Localidades values ( 5149 , 'SALDAN- (CBA)');
INSERT INTO Localidades values ( 5151 , 'LA CALERA- (CBA)');
INSERT INTO Localidades values ( 5152 , 'VILLA CARLOS PAZ- (CBA)');
INSERT INTO Localidades values ( 5153 , 'ICHO CRUZ- (CBA)');
INSERT INTO Localidades values ( 5158 , 'VILLA PARQUE SIQUIMAN  - (CBA)');
INSERT INTO Localidades values ( 5164 , 'SANTA MARIA DE PUNILLA - (CBA)');
INSERT INTO Localidades values ( 5166 , 'COSQUIN  - (CBA)');
INSERT INTO Localidades values ( 5172 , 'LA FALDA - (CBA)');
INSERT INTO Localidades values ( 5174 , 'HUERTA GRANDE- (CBA)');
INSERT INTO Localidades values ( 5176 , 'VILLA GIARDINO  - (CBA)');
INSERT INTO Localidades values ( 5178 , 'LA CUMBRE- (CBA)');
INSERT INTO Localidades values ( 5182 , 'LOS COCOS- (CBA)');
INSERT INTO Localidades values ( 5184 , 'CAPILLA DEL MONTE  - (CBA)');
INSERT INTO Localidades values ( 5186 , 'ALTA GRACIA- (CBA)');
INSERT INTO Localidades values ( 5189 , 'VILLA  ANIZACATE- (CBA)');
INSERT INTO Localidades values ( 5191 , 'SAN AGUSTIN- (CBA)');
INSERT INTO Localidades values ( 5194 , 'VILLA GENERAL BELGRANO - (CBA)');
INSERT INTO Localidades values ( 5196 , 'SANTA ROSA DE CALAMUCHITA - (CBA)');
INSERT INTO Localidades values ( 5200 , 'DEAN FUNES - (CBA)');
INSERT INTO Localidades values ( 5203 , 'TULUMBA  - (CBA)');
INSERT INTO Localidades values ( 5209 , 'SAN FCO. DEL CHAÑAR  - (CBA)');
INSERT INTO Localidades values ( 5212 , 'SARMIENTO- (CBA)');
INSERT INTO Localidades values ( 5214 , 'QUILINO  - (CBA)');
INSERT INTO Localidades values ( 5220 , 'JESUS MARIA- (CBA)');
INSERT INTO Localidades values ( 5223 , 'COLONIA CAROYA  - (CBA)');
INSERT INTO Localidades values ( 5225 , 'OBISPO TREJO - (CBA)');
INSERT INTO Localidades values ( 5229 , 'CHALACEA - (CBA)');
INSERT INTO Localidades values ( 5231 , 'SEBASTIAN ELCANO- (CBA)');
INSERT INTO Localidades values ( 5236 , 'VILLA DEL TOTORAL  - (CBA)');
INSERT INTO Localidades values ( 5238 , 'LAS PEÑAS- (CBA)');
INSERT INTO Localidades values ( 5244 , 'SAN JOSE DE LA DORMIDA - (CBA)');
INSERT INTO Localidades values ( 5246 , 'RAYO CORTADO - (CBA)');
INSERT INTO Localidades values ( 5248 , 'VILLA MARIA DEL RIO SECO  - (CBA)');
INSERT INTO Localidades values ( 5280 , 'CRUZ DEL EJE - (CBA)');
INSERT INTO Localidades values ( 5282 , 'SAN MARCOS SIERRAS - (CBA)');
INSERT INTO Localidades values ( 5284 , 'VILLA DE SOTO- (CBA)');
INSERT INTO Localidades values ( 5291 , 'SAN CARLOS MINAS- (CBA)');
INSERT INTO Localidades values ( 5295 , 'SALSACATE- (CBA)');
INSERT INTO Localidades values ( 5800 , 'RIO CUARTO - (CBA)');
INSERT INTO Localidades values ( 5801 , 'ALPA CORRAL- (CBA)');
INSERT INTO Localidades values ( 5803 , 'REDUCCION- (CBA)');
INSERT INTO Localidades values ( 5805 , 'LAS HIGUERAS - (CBA)');
INSERT INTO Localidades values ( 5807 , 'CHARRAS  - (CBA)');
INSERT INTO Localidades values ( 5809 , 'GENERAL CABRERA - (CBA)');
INSERT INTO Localidades values ( 5811 , 'CORONEL BAIGORRIA  - (CBA)');
INSERT INTO Localidades values ( 5813 , 'ALCIRA GIGENA- (CBA)');
INSERT INTO Localidades values ( 5815 , 'ELENA - (CBA)');
INSERT INTO Localidades values ( 5817 , 'BERROTARAN - (CBA)');
INSERT INTO Localidades values ( 5819 , 'LAS PEÑAS SUD- (CBA)');
INSERT INTO Localidades values ( 5821 , 'RIO DE LOS SAUCES  - (CBA)');
INSERT INTO Localidades values ( 5823 , 'LOS CONDORES - (CBA)');
INSERT INTO Localidades values ( 5825 , 'HOLMBERG - (CBA)');
INSERT INTO Localidades values ( 5829 , 'SAMPACHO - (CBA)');
INSERT INTO Localidades values ( 5833 , 'ACHIRAS  - (CBA)');
INSERT INTO Localidades values ( 5837 , 'CHAJAN- (CBA)');
INSERT INTO Localidades values ( 5839 , 'MALENA- (CBA)');
INSERT INTO Localidades values ( 5841 , 'SAN BASILIO- (CBA)');
INSERT INTO Localidades values ( 5843 , 'ADELIA MARIA - (CBA)');
INSERT INTO Localidades values ( 5845 , 'BULNES- (CBA)');
INSERT INTO Localidades values ( 5847 , 'CORONEL MOLDES  - (CBA)');
INSERT INTO Localidades values ( 5848 , 'LAS ACEQUIAS - (CBA)');
INSERT INTO Localidades values ( 5850 , 'RIO TERCERO- (CBA)');
INSERT INTO Localidades values ( 5853 , 'CORRALITO- (CBA)');
INSERT INTO Localidades values ( 5854 , 'ALMAFUERTE - (CBA)');
INSERT INTO Localidades values ( 5856 , 'EMBALSE  - (CBA)');
INSERT INTO Localidades values ( 5857 , 'VILLA SANTA ISABEL - (CBA)');
INSERT INTO Localidades values ( 5859 , 'LA CRUZ  - (CBA)');
INSERT INTO Localidades values ( 5862 , 'VILLA DEL DIQUE - (CBA)');
INSERT INTO Localidades values ( 5864 , 'VILLA RUMIPAL- (CBA)');
INSERT INTO Localidades values ( 5870 , 'VILLA DOLORES- (CBA)');
INSERT INTO Localidades values ( 5885 , 'LOS HORNILLOS- (CBA)');
INSERT INTO Localidades values ( 5889 , 'MINA CRAVERO - (CBA)');
INSERT INTO Localidades values ( 5900 , 'VILLA MARIA- (CBA)');
INSERT INTO Localidades values ( 5901 , 'LA LAGUNA- (CBA)');
INSERT INTO Localidades values ( 5903 , 'VILLA NUEVA- (CBA)');
INSERT INTO Localidades values ( 5907 , 'SILVIO PELLICO  - (CBA)');
INSERT INTO Localidades values ( 5909 , 'ARROYO ALGODON  - (CBA)');
INSERT INTO Localidades values ( 5911 , 'LA PLAYOSA - (CBA)');
INSERT INTO Localidades values ( 5913 , 'POZO DEL MOLLE  - (CBA)');
INSERT INTO Localidades values ( 5915 , 'CARRILOBO- (CBA)');
INSERT INTO Localidades values ( 5917 , 'ARROYO CABRAL- (CBA)');
INSERT INTO Localidades values ( 5921 , 'LAS PERDICES - (CBA)');
INSERT INTO Localidades values ( 5923 , 'GENERAL DEHEZA  - (CBA)');
INSERT INTO Localidades values ( 5925 , 'PASCO - (CBA)');
INSERT INTO Localidades values ( 5927 , 'TICINO- (CBA)');
INSERT INTO Localidades values ( 5929 , 'HERNANDO - (CBA)');
INSERT INTO Localidades values ( 5931 , 'LAS ISLETILLAS  - (CBA)');
INSERT INTO Localidades values ( 5933 , 'TANCACHA - (CBA)');
INSERT INTO Localidades values ( 5935 , 'VILLA ASCASUBI  - (CBA)');
INSERT INTO Localidades values ( 5936 , 'TIO PUJIO- (CBA)');
INSERT INTO Localidades values ( 5940 , 'LAS VARILLAS - (CBA)');
INSERT INTO Localidades values ( 5941 , 'LAS VARAS- (CBA)');
INSERT INTO Localidades values ( 5943 , 'SATURNINO MARIA LAS PIUR  - (CBA)');
INSERT INTO Localidades values ( 5945 , 'SACANTA  - (CBA)');
INSERT INTO Localidades values ( 5947 , 'EL ARAÑADO - (CBA)');
INSERT INTO Localidades values ( 5949 , 'ALICIA- (CBA)');
INSERT INTO Localidades values ( 5951 , 'EL FORTIN- (CBA)');
INSERT INTO Localidades values ( 5960 , 'RIO SEGUNDO- (CBA)');
INSERT INTO Localidades values ( 5963 , 'VILLA DEL ROSARIO  - (CBA)');
INSERT INTO Localidades values ( 5965 , 'MATORRALES - (CBA)');
INSERT INTO Localidades values ( 5967 , 'LUQUE - (CBA)');
INSERT INTO Localidades values ( 5969 , 'CALCHIN OESTE- (CBA)');
INSERT INTO Localidades values ( 5971 , 'LAS JUNTURAS - (CBA)');
INSERT INTO Localidades values ( 5972 , 'PILAR - (CBA)');
INSERT INTO Localidades values ( 5974 , 'LAGUNA LARGA - (CBA)');
INSERT INTO Localidades values ( 5980 , 'OLIVA - (CBA)');
INSERT INTO Localidades values ( 5981 , 'COLAZO- (CBA)');
INSERT INTO Localidades values ( 5984 , 'JAMES CRAICK - (CBA)');
INSERT INTO Localidades values ( 5986 , 'ONCATIVO - (CBA)');
INSERT INTO Localidades values ( 6101 , 'LA CESIRA- (CBA)');
INSERT INTO Localidades values ( 6120 , 'LABOULAYE- (CBA)');
INSERT INTO Localidades values ( 6121 , 'HUANCHILLA - (CBA)');
INSERT INTO Localidades values ( 6123 , 'MELO- (CBA)');
INSERT INTO Localidades values ( 6125 , 'SERRANO  - (CBA)');
INSERT INTO Localidades values ( 6127 , 'JOVITA- (CBA)');
INSERT INTO Localidades values ( 6132 , 'GENERAL LEVALLE - (CBA)');
INSERT INTO Localidades values ( 6140 , 'VICUÑA MACKENNA - (CBA)');
INSERT INTO Localidades values ( 6141 , 'LAS ALBAHACAS- (CBA)');
INSERT INTO Localidades values ( 6225 , 'H. BUCHARD - (CBA)');
INSERT INTO Localidades values ( 6270 , 'HUINCA RENANCO  - (CBA)');
INSERT INTO Localidades values ( 6271 , 'DEL CAMPILLO - (CBA)');
INSERT INTO Localidades values ( 6273 , 'VILLA VALERIA- (CBA)');
INSERT INTO Localidades values ( 6275 , 'VILLA HUIDOBRO  - (CBA)');
INSERT INTO Localidades values ( 7021 , 'BENGOLEA - (CBA)');
INSERT INTO Localidades values ( 11406 , 'BIALET MASSE - (CBA)');
INSERT INTO Localidades values ( 12417 , 'ALTOS DE CHIPION- (CBA)');
INSERT INTO Localidades values ( 12419 , 'COLONIA VIGNAUD - (CBA)');
INSERT INTO Localidades values ( 12424 , 'COLONIA MARINA  - (CBA)');
INSERT INTO Localidades values ( 12426 , 'COLONIA SAN BARTOLOME  - (CBA)');
INSERT INTO Localidades values ( 12559 , 'SAN ANTONIO DE LITIN - (CBA)');
INSERT INTO Localidades values ( 12583 , 'GENERAl  BALDISSERA  - (CBA)');
INSERT INTO Localidades values ( 12645 , 'CAP. GRAL. BDO. O´HIGGINS - (CBA)');
INSERT INTO Localidades values ( 12671 , 'VIAMONTE - (CBA)');
INSERT INTO Localidades values ( 14300 , 'RUTA NAC. 8 KM. 623  - (CBA)');
INSERT INTO Localidades values ( 15000 , 'BARRIO PUEYRREDON  - (CBA)');
INSERT INTO Localidades values ( 15001 , 'AV. LEANDRO N. ALEM  - (CBA)');
INSERT INTO Localidades values ( 15003 , 'BARRIO ALTO ALBERDI  - (CBA)');
INSERT INTO Localidades values ( 15006 , 'AV. SABATINI 4424  - (CBA)');
INSERT INTO Localidades values ( 15008 , 'Bº MARQUES DE SOBREMONTE  - (CBA)');
INSERT INTO Localidades values ( 15009 , 'VIRGEN DE LA MERCED 2300  - (CBA)');
INSERT INTO Localidades values ( 15010 , 'AV. FZA.AEREA ARGENT.2468 - (CBA)');
INSERT INTO Localidades values ( 15012 , 'BARRIO YOFRE NORTE - (CBA)');
INSERT INTO Localidades values ( 15014 , 'BARRIO SARMIENTO- (CBA)');
INSERT INTO Localidades values ( 15016 , 'BARRIO LAS FLORES  - (CBA)');
INSERT INTO Localidades values ( 15017 , 'BARRIO LOS OLMOS- (CBA)');
INSERT INTO Localidades values ( 15101 , 'VILLA ESQUIU - (CBA)');
INSERT INTO Localidades values ( 15125 , 'SANTIAGO TEMPLE - (CBA)');
INSERT INTO Localidades values ( 15137 , 'LA PUERTA- (CBA)');
INSERT INTO Localidades values ( 15147 , 'ARGUELLO - (CBA)');
INSERT INTO Localidades values ( 15152 , 'SANTA CRUZ DEL LAGO  - (CBA)');
INSERT INTO Localidades values ( 15164 , 'VILLA CAEIRO - (CBA)');
INSERT INTO Localidades values ( 15231 , 'LAS ARRIAS - (CBA)');
INSERT INTO Localidades values ( 15248 , 'VILLA DE MARIA  - (CBA)');
INSERT INTO Localidades values ( 15805 , 'CARNERILLO - (CBA)');
INSERT INTO Localidades values ( 15825 , 'LAS  ENSENADAS  - (CBA)');
INSERT INTO Localidades values ( 15901 , 'AUSONIA  - (CBA)');
INSERT INTO Localidades values ( 15917 , 'LUCA- (CBA)');
INSERT INTO Localidades values ( 15919 , 'DALMACIO V. SARFIELD - (CBA)');
INSERT INTO Localidades values ( 15933 , 'GENERAL FOTHERINGHAN - (CBA)');
INSERT INTO Localidades values ( 15965 , 'LAS JUNTURAS - (CBA)');
INSERT INTO Localidades values ( 15969 , 'CALCHIN  - (CBA)');
INSERT INTO Localidades values ( 16225 , 'HIPOLITO BOUCHARD  - (CBA)');
INSERT INTO Localidades values ( 16271 , 'DEL CAMPILLO - (CBA)');
INSERT INTO Localidades values ( 25000 , 'BARRIO SAN FELIPE  - (CBA)');
INSERT INTO Localidades values ( 25001 , 'AV. JUAN B. JUSTO 3808 - (CBA)');
INSERT INTO Localidades values ( 25006 , 'ENTRE RIOS 2699 - (CBA)');
INSERT INTO Localidades values ( 25008 , 'CARDEÑOSA y F.L.BELTRAN- (CBA)');
INSERT INTO Localidades values ( 25009 , 'AV. RAFAEL NUÑEZ 3884  - (CBA)');
INSERT INTO Localidades values ( 25010 , 'BARRIO AMEGHINO SUD  - (CBA)');
INSERT INTO Localidades values ( 25012 , 'BARRIO SAN VICENTE - (CBA)');
INSERT INTO Localidades values ( 25014 , 'AV. RICHIERI - (CBA)');
INSERT INTO Localidades values ( 25016 , 'BARRIO PARQUE HORIZONTE- (CBA)');
INSERT INTO Localidades values ( 25017 , 'BARRIO LIBERTADOR  - (CBA)');
INSERT INTO Localidades values ( 25125 , 'LOS CHAÑARITOS  - (CBA)');
INSERT INTO Localidades values ( 25137 , 'VILLA FONTANA- (CBA)');
INSERT INTO Localidades values ( 25147 , 'VILLA CLARET - (CBA)');
INSERT INTO Localidades values ( 25164 , 'VILLA BUSTOS - (CBA)');
INSERT INTO Localidades values ( 26271 , 'DEL CAMPILLO - (CBA)');
INSERT INTO Localidades values ( 35000 , 'BARRIO NUEVA CORDOBA - (CBA)');
INSERT INTO Localidades values ( 35001 , 'JUAN B. JUSTO 3410 - (CBA)');
INSERT INTO Localidades values ( 35006 , 'BARRIO ALTAMIRA - (CBA)');
INSERT INTO Localidades values ( 35009 , 'CERRO DE LAS ROSAS - (CBA)');
INSERT INTO Localidades values ( 35010 , 'Bº VILLA ADELA  - (CBA)');
INSERT INTO Localidades values ( 35014 , 'BARRIO CRISOL- (CBA)');
INSERT INTO Localidades values ( 35016 , 'AV. VELEZ SARSFIELD  3201 - (CBA)');
INSERT INTO Localidades values ( 35125 , 'PIQUILLIN- (CBA)');
INSERT INTO Localidades values ( 35147 , 'AV. RECTA MARTINOLI  - (CBA)');
INSERT INTO Localidades values ( 45000 , 'BARRIO ALTO V. SARFIELD- (CBA)');
INSERT INTO Localidades values ( 45001 , 'JERONIMO L.de CABRERA 653 - (CBA)');
INSERT INTO Localidades values ( 45006 , 'BARRIO SAN VICENTE - (CBA)');
INSERT INTO Localidades values ( 45009 , 'BARRIO BAJO PALERMO  - (CBA)');
INSERT INTO Localidades values ( 45010 , 'BARRIO LOS  GRANADOS - (CBA)');
INSERT INTO Localidades values ( 45014 , 'BARRIO COLON - (CBA)');
INSERT INTO Localidades values ( 45016 , 'BARRIO MIRIZZI  - (CBA)');
INSERT INTO Localidades values ( 45147 , 'BARRIO VILLA BELGRANO  - (CBA)');
INSERT INTO Localidades values ( 55000 , 'BARRIO ALTA CORDOBA  - (CBA)');
INSERT INTO Localidades values ( 55001 , 'AV. COLON  724  - (CBA)');
INSERT INTO Localidades values ( 55006 , 'BARRIO GUEMES- (CBA)');
INSERT INTO Localidades values ( 55009 , 'AVDA. E. CARAFFA  2624 - (CBA)');
INSERT INTO Localidades values ( 55014 , 'AV. REVOLUCION DE MAYO - (CBA)');
INSERT INTO Localidades values ( 55147 , 'BARRIO LOS BOULEVARES  - (CBA)');
INSERT INTO Localidades values ( 58000 , 'CHUCUL- (CBA)');
INSERT INTO Localidades values ( 65000 , 'BARRIO GENERAL BUSTOS  - (CBA)');
INSERT INTO Localidades values ( 65001 , 'BARRIO SAN MARTIN  - (CBA)');
INSERT INTO Localidades values ( 65006 , 'BARRIO  EMPALME - (CBA)');
INSERT INTO Localidades values ( 65009 , 'BARRIO ALTO PALERMO  - (CBA)');
INSERT INTO Localidades values ( 65014 , 'BARRIO LOURDES  - (CBA)');
INSERT INTO Localidades values ( 65147 , 'BARRIO VILLA ALLENDE PQUE - (CBA)');
INSERT INTO Localidades values ( 75000 , 'BARRIO  JUNIOR  - (CBA)');
INSERT INTO Localidades values ( 85000 , 'BARRIO  BALCARCE- (CBA)');
INSERT INTO Localidades values ( 85009 , 'BARRIO GRANJA DE FUNES - (CBA)');
INSERT INTO Localidades values ( 95000 , 'BARRIO  ESCOBAR - (CBA)');
INSERT INTO Localidades values ( 105000 , 'BARRIO CORONEL OLMEDO  - (CBA)');
INSERT INTO Localidades values ( 115000 , 'BARRIO  SAN  JAVIER  - (CBA)');
INSERT INTO Localidades values ( 115147 , 'Bº LOS BOULEVARES  - (CBA)');
INSERT INTO Localidades values ( 125000 , 'BARRIO  ALBERDI - (CBA)');


INSERT INTO Localidades values	(	101	, 'SAENZ PEÑA- (Bs As)'	)	;
INSERT INTO Localidades values	(	1000	, 'LOMA HERMOSA - (Bs As)'	)	;
INSERT INTO Localidades values	(	1003	, 'BUENOS AIRES - (Bs As)'	)	;
INSERT INTO Localidades values	(	1004	, 'BUENOS AIRES - (Bs As)'	)	;
INSERT INTO Localidades values	(	1005	, 'FLORIDA  199 - (Bs As)'	)	;
INSERT INTO Localidades values	(	1008	, 'BUENOS AIRES - (Bs As)'	)	;
INSERT INTO Localidades values	(	1009	, 'BUENOS AIRES - (Bs As)'	)	;
INSERT INTO Localidades values	(	1012	, 'QUINTANA 101 - (Bs As)'	)	;
INSERT INTO Localidades values	(	1017	, 'CAPITAL FEDERAL  - (Bs As)'	)	;
INSERT INTO Localidades values	(	1028	, 'CAPITAL FEDERAL  - (Bs As)'	)	;
INSERT INTO Localidades values	(	1033	, 'BUENOS AIRES - (Bs As)'	)	;
INSERT INTO Localidades values	(	1035	, 'BUENOS AIRES - (Bs As)'	)	;
INSERT INTO Localidades values	(	1038	, 'TTE.GRAL.JUAN D.PERON 407- (Bs As)'	)	;
INSERT INTO Localidades values	(	1060	, 'BUENOS AIRES - (Bs As)'	)	;
INSERT INTO Localidades values	(	1063	, 'BUENOS AIRES - (Bs As)'	)	;
INSERT INTO Localidades values	(	1064	, 'BUENOS AIRES - (Bs As)'	)	;
INSERT INTO Localidades values	(	1067	, 'AV. PTE. JULIO A. ROCA 53- (Bs As)'	)	;
INSERT INTO Localidades values	(	1068	, 'CAPITAL FEDERAL  - (Bs As)'	)	;
INSERT INTO Localidades values	(	1069	, 'AVDA. DE MAYO- (Bs As)'	)	;
INSERT INTO Localidades values	(	1070	, 'CAPITAL FEDERAL  - (Bs As)'	)	;
INSERT INTO Localidades values	(	1075	, 'SANTIAGO DEL ESTERO 446  - (Bs As)'	)	;
INSERT INTO Localidades values	(	1079	, 'CAPITAL FEDERAL  - (Bs As)'	)	;
INSERT INTO Localidades values	(	1084	, 'CAPITAL FEDERAL  - (Bs As)'	)	;
INSERT INTO Localidades values	(	1087	, 'BUENOS AIRES - (Bs As)'	)	;
INSERT INTO Localidades values	(	1088	, 'BUENOS AIRES - (Bs As)'	)	;
INSERT INTO Localidades values	(	1091	, 'BUENOS AIRES - (Bs As)'	)	;
INSERT INTO Localidades values	(	1092	, 'BUENOS AIRES - (Bs As)'	)	;
INSERT INTO Localidades values	(	1104	, 'BUENOS AIRES - (Bs As)'	)	;
INSERT INTO Localidades values	(	1107	, 'CAPITAL FEDERAL  - (Bs As)'	)	;
INSERT INTO Localidades values	(	1120	, 'BUENOS AIRES - (Bs As)'	)	;
INSERT INTO Localidades values	(	1129	, 'BS. AS. AV. QUINTANA  401- (Bs As)'	)	;
INSERT INTO Localidades values	(	1133	, 'AV. ENTRE RIOS 1692  - (Bs As)'	)	;
INSERT INTO Localidades values	(	1136	, 'CAPITAL FEDERAL  - (Bs As)'	)	;
INSERT INTO Localidades values	(	1147	, 'BUENOS AIRES - (Bs As)'	)	;
INSERT INTO Localidades values	(	1148	, 'CAPITAL FEDERAL  - (Bs As)'	)	;
INSERT INTO Localidades values	(	1159	, 'AV. ALTE. BROWN  826 - (Bs As)'	)	;
INSERT INTO Localidades values	(	1182	, 'CIUDAD AUTONOMA DE BS. AS- (Bs As)'	)	;
INSERT INTO Localidades values	(	1184	, 'CAPITAL FEDERAL  - (Bs As)'	)	;
INSERT INTO Localidades values	(	1186	, 'CAPITAL FEDERAL  - (Bs As)'	)	;
INSERT INTO Localidades values	(	1197	, 'CDAD AUTON DE BS. AS.- (Bs As)'	)	;
INSERT INTO Localidades values	(	1198	, 'CAPITAL FEDERAL  - (Bs As)'	)	;
INSERT INTO Localidades values	(	1200	, 'CAPITAL FEDERAL  - (Bs As)'	)	;
INSERT INTO Localidades values	(	1203	, 'BUENOS AIRES - (Bs As)'	)	;
INSERT INTO Localidades values	(	1204	, 'AV RIVADAVIA - (Bs As)'	)	;
INSERT INTO Localidades values	(	1213	, 'CIUDAD AUTONOMA BS. AS.  - (Bs As)'	)	;
INSERT INTO Localidades values	(	1214	, 'BUENOS AIRES - (Bs As)'	)	;
INSERT INTO Localidades values	(	1215	, 'CAPITAL FEDERAL  - (Bs As)'	)	;
INSERT INTO Localidades values	(	1233	, 'BUENOS AIRES - (Bs As)'	)	;
INSERT INTO Localidades values	(	1234	, 'LOMAS DEL MIRADOR- (Bs As)'	)	;
INSERT INTO Localidades values	(	1250	, 'CAPITAL FEDERAL  - (Bs As)'	)	;
INSERT INTO Localidades values	(	1270	, 'AVDA. MONTE DE OCA 895- (Bs As)'	)	;
INSERT INTO Localidades values	(	1271	, 'BUENOS AIRES - (Bs As)'	)	;
INSERT INTO Localidades values	(	1275	, 'CAPITAL FEDERAL  - (Bs As)'	)	;
INSERT INTO Localidades values	(	1282	, 'BUENOS AIRES - (Bs As)'	)	;
INSERT INTO Localidades values	(	1292	, 'CAPITAL FEDERAL  - (Bs As)'	)	;
INSERT INTO Localidades values	(	1293	, 'CAPITAL FEDERAL  - (Bs As)'	)	;
INSERT INTO Localidades values	(	1306	, 'CAPITAL FEDERAL  - (Bs As)'	)	;
INSERT INTO Localidades values	(	1324	, 'AVDA. CORRIENTES 629 - (Bs As)'	)	;
INSERT INTO Localidades values	(	1335	, 'BUENOS AIRES - (Bs As)'	)	;
INSERT INTO Localidades values	(	1378	, 'BUENOS AIRES - (Bs As)'	)	;
INSERT INTO Localidades values	(	1406	, 'CAPITAL FEDERAL  - (Bs As)'	)	;
INSERT INTO Localidades values	(	1407	, 'CAPITAL FEDERAL  - (Bs As)'	)	;
INSERT INTO Localidades values	(	1414	, 'BUENOS AIRES - (Bs As)'	)	;
INSERT INTO Localidades values	(	1416	, 'CAPITAL FEDERAL  - (Bs As)'	)	;
INSERT INTO Localidades values	(	1417	, 'CAPITAL FEDERAL  - (Bs As)'	)	;
INSERT INTO Localidades values	(	1419	, 'CAPITAL FEDERAL  - (Bs As)'	)	;
INSERT INTO Localidades values	(	1424	, 'AVELLANEDA- (Bs As)'	)	;
INSERT INTO Localidades values	(	1425	, 'BUENOS AIRES - (Bs As)'	)	;
INSERT INTO Localidades values	(	1427	, 'CAPITAL FEDERAL  - (Bs As)'	)	;
INSERT INTO Localidades values	(	1428	, 'BUENOS AIRES - (Bs As)'	)	;
INSERT INTO Localidades values	(	1429	, 'AV. CABILDO  3702- (Bs As)'	)	;
INSERT INTO Localidades values	(	1431	, 'CAPITAL FEDERAL  - (Bs As)'	)	;
INSERT INTO Localidades values	(	1437	, 'CAPITAL FEDERAL  - (Bs As)'	)	;
INSERT INTO Localidades values	(	1439	, 'CAPITAL FEDERAL  - (Bs As)'	)	;
INSERT INTO Localidades values	(	1440	, 'BUENOS AIRES - (Bs As)'	)	;
INSERT INTO Localidades values	(	1460	, 'AVELLANEDA- (Bs As)'	)	;
INSERT INTO Localidades values	(	1602	, 'FLORIDA- (Bs As)'	)	;
INSERT INTO Localidades values	(	1603	, 'VILLA MARTELLI- (Bs As)'	)	;
INSERT INTO Localidades values	(	1604	, 'FLORIDA OESTE- (Bs As)'	)	;
INSERT INTO Localidades values	(	1605	, 'MUNRO - (Bs As)'	)	;
INSERT INTO Localidades values	(	1607	, 'VILLA ADELINA- (Bs As)'	)	;
INSERT INTO Localidades values	(	1608	, 'TIGRE - (Bs As)'	)	;
INSERT INTO Localidades values	(	1609	, 'BOULOGNE  - (Bs As)'	)	;
INSERT INTO Localidades values	(	1611	, 'DON TORCUATO - (Bs As)'	)	;
INSERT INTO Localidades values	(	1613	, 'LOS POLVORINES- (Bs As)'	)	;
INSERT INTO Localidades values	(	1615	, 'GRAND BOURG  - (Bs As)'	)	;
INSERT INTO Localidades values	(	1617	, 'GENERAL PACHECO  - (Bs As)'	)	;
INSERT INTO Localidades values	(	1618	, 'EL TALAR  - (Bs As)'	)	;
INSERT INTO Localidades values	(	1619	, 'GARIN - (Bs As)'	)	;
INSERT INTO Localidades values	(	1623	, 'BUENOS AIRES - (Bs As)'	)	;
INSERT INTO Localidades values	(	1625	, 'ESCOBAR- (Bs As)'	)	;
INSERT INTO Localidades values	(	1627	, 'MATHEU- (Bs As)'	)	;
INSERT INTO Localidades values	(	1629	, 'PILAR - (Bs As)'	)	;
INSERT INTO Localidades values	(	1636	, 'OLIVOS- (Bs As)'	)	;
INSERT INTO Localidades values	(	1638	, 'VICENTE LOPEZ- (Bs As)'	)	;
INSERT INTO Localidades values	(	1640	, 'MARTINEZ  - (Bs As)'	)	;
INSERT INTO Localidades values	(	1641	, 'ACASSUSO  - (Bs As)'	)	;
INSERT INTO Localidades values	(	1642	, 'SAN ISIDRO- (Bs As)'	)	;
INSERT INTO Localidades values	(	1643	, 'BECCAR- (Bs As)'	)	;
INSERT INTO Localidades values	(	1644	, 'VICTORIA  - (Bs As)'	)	;
INSERT INTO Localidades values	(	1646	, 'SAN FERNANDO - (Bs As)'	)	;
INSERT INTO Localidades values	(	1648	, 'TIGRE - (Bs As)'	)	;
INSERT INTO Localidades values	(	1650	, 'GRAL. SAN MARTIN - (Bs As)'	)	;
INSERT INTO Localidades values	(	1651	, 'SAN ANDRES- (Bs As)'	)	;
INSERT INTO Localidades values	(	1653	, 'VILLA BALLESTER  - (Bs As)'	)	;
INSERT INTO Localidades values	(	1655	, 'JOSE LEON SUAREZ - (Bs As)'	)	;
INSERT INTO Localidades values	(	1657	, 'VILLA LOMA HERMOSA- (Bs As)'	)	;
INSERT INTO Localidades values	(	1661	, 'BELLA VISTA  - (Bs As)'	)	;
INSERT INTO Localidades values	(	1663	, 'SAN MIGUEL- (Bs As)'	)	;
INSERT INTO Localidades values	(	1665	, 'JOSE  C. PAZ - (Bs As)'	)	;
INSERT INTO Localidades values	(	1667	, 'TORTUGUITAS  - (Bs As)'	)	;
INSERT INTO Localidades values	(	1669	, 'DELVISO- (Bs As)'	)	;
INSERT INTO Localidades values	(	1672	, 'SAN MARTIN- (Bs As)'	)	;
INSERT INTO Localidades values	(	1674	, 'SAENZ PEÑA- (Bs As)'	)	;
INSERT INTO Localidades values	(	1675	, 'SAENZ PEÑA- (Bs As)'	)	;
INSERT INTO Localidades values	(	1676	, 'BERNAL- (Bs As)'	)	;
INSERT INTO Localidades values	(	1678	, 'CASEROS- (Bs As)'	)	;
INSERT INTO Localidades values	(	1682	, 'VILLA BOSCH  - (Bs As)'	)	;
INSERT INTO Localidades values	(	1684	, 'EL PALOMAR- (Bs As)'	)	;
INSERT INTO Localidades values	(	1686	, 'HURLINGHAM- (Bs As)'	)	;
INSERT INTO Localidades values	(	1702	, 'CIUDADELA - (Bs As)'	)	;
INSERT INTO Localidades values	(	1704	, 'RAMOS MEJIA  - (Bs As)'	)	;
INSERT INTO Localidades values	(	1706	, 'V.SARMIENTO (ptdo MORON) - (Bs As)'	)	;
INSERT INTO Localidades values	(	1708	, 'MORON - (Bs As)'	)	;
INSERT INTO Localidades values	(	1712	, 'CASTELAR  - (Bs As)'	)	;
INSERT INTO Localidades values	(	1714	, 'ITUZAINGO - (Bs As)'	)	;
INSERT INTO Localidades values	(	1716	, 'LIBERTAD  - (Bs As)'	)	;
INSERT INTO Localidades values	(	1718	, 'SAN ANTONIO DE PADUA - (Bs As)'	)	;
INSERT INTO Localidades values	(	1722	, 'MERLO - (Bs As)'	)	;
INSERT INTO Localidades values	(	1727	, 'MARCOS PAZ- (Bs As)'	)	;
INSERT INTO Localidades values	(	1741	, 'GENERAL LAS HERAS- (Bs As)'	)	;
INSERT INTO Localidades values	(	1742	, 'PASO DEL REY - (Bs As)'	)	;
INSERT INTO Localidades values	(	1744	, 'MORENO- (Bs As)'	)	;
INSERT INTO Localidades values	(	1745	, 'MORENO- (Bs As)'	)	;
INSERT INTO Localidades values	(	1748	, 'GENERAL RODRIGUEZ- (Bs As)'	)	;
INSERT INTO Localidades values	(	1752	, 'LOMAS DEL MIRADOR- (Bs As)'	)	;
INSERT INTO Localidades values	(	1754	, 'SAN JUSTO - (Bs As)'	)	;
INSERT INTO Localidades values	(	1755	, 'RAFAEL CASTILLO  - (Bs As)'	)	;
INSERT INTO Localidades values	(	1757	, 'LAFERRERE - (Bs As)'	)	;
INSERT INTO Localidades values	(	1761	, 'PONTEVEDRA- (Bs As)'	)	;
INSERT INTO Localidades values	(	1763	, 'GONZALEZ CATÀN- (Bs As)'	)	;
INSERT INTO Localidades values	(	1765	, 'ISIDRO CASANOVA  - (Bs As)'	)	;
INSERT INTO Localidades values	(	1766	, 'LA TABLADA- (Bs As)'	)	;
INSERT INTO Localidades values	(	1768	, 'VILLA MADERO - (Bs As)'	)	;
INSERT INTO Localidades values	(	1770	, 'ALDO BONZI- (Bs As)'	)	;
INSERT INTO Localidades values	(	1771	, 'VILLA CELINA - (Bs As)'	)	;
INSERT INTO Localidades values	(	1772	, 'AV. B.SUR MER Y RICHIERI - (Bs As)'	)	;
INSERT INTO Localidades values	(	1778	, 'CIUDAD EVITA - (Bs As)'	)	;
INSERT INTO Localidades values	(	1802	, 'AEROPUERTO INTERN. EZEIZA- (Bs As)'	)	;
INSERT INTO Localidades values	(	1804	, 'EZEIZA- (Bs As)'	)	;
INSERT INTO Localidades values	(	1812	, 'CARLOS SPEGAZZINI- (Bs As)'	)	;
INSERT INTO Localidades values	(	1814	, 'CAÑUELAS  - (Bs As)'	)	;
INSERT INTO Localidades values	(	1822	, 'VALENTIN ALSINA  - (Bs As)'	)	;
INSERT INTO Localidades values	(	1824	, 'LANUS - (Bs As)'	)	;
INSERT INTO Localidades values	(	1825	, 'MONTE CHINGOLO- (Bs As)'	)	;
INSERT INTO Localidades values	(	1826	, 'REMEDIOS DE ESCALADA - (Bs As)'	)	;
INSERT INTO Localidades values	(	1828	, 'BANFIELD  - (Bs As)'	)	;
INSERT INTO Localidades values	(	1832	, 'LOMAS DE ZAMORA  - (Bs As)'	)	;
INSERT INTO Localidades values	(	1834	, 'TEMPERLEY - (Bs As)'	)	;
INSERT INTO Localidades values	(	1836	, 'LAVALLOL  - (Bs As)'	)	;
INSERT INTO Localidades values	(	1838	, 'LUIS GUILLON - (Bs As)'	)	;
INSERT INTO Localidades values	(	1842	, 'MONTE GRANDE - (Bs As)'	)	;
INSERT INTO Localidades values	(	1846	, 'ADROGUE- (Bs As)'	)	;
INSERT INTO Localidades values	(	1847	, 'RAFAEL CALZADA- (Bs As)'	)	;
INSERT INTO Localidades values	(	1852	, 'BURZACO- (Bs As)'	)	;
INSERT INTO Localidades values	(	1854	, 'LONGCHAMPS- (Bs As)'	)	;
INSERT INTO Localidades values	(	1856	, 'GLEW  - (Bs As)'	)	;
INSERT INTO Localidades values	(	1862	, 'GUERNICA  - (Bs As)'	)	;
INSERT INTO Localidades values	(	1864	, 'ALEJANDRO KORN- (Bs As)'	)	;
INSERT INTO Localidades values	(	1865	, 'SAN VICENTE  - (Bs As)'	)	;
INSERT INTO Localidades values	(	1870	, 'AVELLANEDA- (Bs As)'	)	;
INSERT INTO Localidades values	(	1871	, 'DOCK SUD  - (Bs As)'	)	;
INSERT INTO Localidades values	(	1874	, 'VILLA DOMINICO- (Bs As)'	)	;
INSERT INTO Localidades values	(	1875	, 'WILDE - (Bs As)'	)	;
INSERT INTO Localidades values	(	1876	, 'BERNAL- (Bs As)'	)	;
INSERT INTO Localidades values	(	1878	, 'QUILMES- (Bs As)'	)	;
INSERT INTO Localidades values	(	1879	, 'QUILMES- (Bs As)'	)	;
INSERT INTO Localidades values	(	1881	, 'SAN FRANCISCO SOLANO - (Bs As)'	)	;
INSERT INTO Localidades values	(	1882	, 'EZPELETA  - (Bs As)'	)	;
INSERT INTO Localidades values	(	1884	, 'BERAZATEGUI  - (Bs As)'	)	;
INSERT INTO Localidades values	(	1885	, 'PLATANOS - BERAZATEGUI- (Bs As)'	)	;
INSERT INTO Localidades values	(	1888	, 'FLORENCIO VARELA - (Bs As)'	)	;
INSERT INTO Localidades values	(	1889	, 'BOSQUES- (Bs As)'	)	;
INSERT INTO Localidades values	(	1896	, 'CITY BELL - (Bs As)'	)	;
INSERT INTO Localidades values	(	1897	, 'GONNET- (Bs As)'	)	;
INSERT INTO Localidades values	(	1900	, 'LA PLATA  - (Bs As)'	)	;
INSERT INTO Localidades values	(	1901	, 'L. OLMOS  - (Bs As)'	)	;
INSERT INTO Localidades values	(	1913	, 'MAGDALENA - (Bs As)'	)	;
INSERT INTO Localidades values	(	1917	, 'VERONICA  - (Bs As)'	)	;
INSERT INTO Localidades values	(	1923	, 'BERISSO- (Bs As)'	)	;
INSERT INTO Localidades values	(	1925	, 'ENSENADA  - (Bs As)'	)	;
INSERT INTO Localidades values	(	1933	, 'ABASTO - LA PLATA- (Bs As)'	)	;
INSERT INTO Localidades values	(	1980	, 'BRANDSEN  - (Bs As)'	)	;
INSERT INTO Localidades values	(	1987	, 'GENERAL PAZ  - (Bs As)'	)	;
INSERT INTO Localidades values	(	2175	, 'VILLA MUGUETA- (Bs As)'	)	;
INSERT INTO Localidades values	(	2700	, 'PERGAMINO - (Bs As)'	)	;
INSERT INTO Localidades values	(	2705	, 'ROJAS - (Bs As)'	)	;
INSERT INTO Localidades values	(	2715	, 'EL SOCORRO- (Bs As)'	)	;
INSERT INTO Localidades values	(	2720	, 'COLON - (Bs As)'	)	;
INSERT INTO Localidades values	(	2740	, 'ARRECIFE  - (Bs As)'	)	;
INSERT INTO Localidades values	(	2741	, 'SALTO - (Bs As)'	)	;
INSERT INTO Localidades values	(	2752	, 'CAP. SARMIENTO- (Bs As)'	)	;
INSERT INTO Localidades values	(	2760	, 'SAN ANTONIO DE ARECO - (Bs As)'	)	;
INSERT INTO Localidades values	(	2800	, 'ZARATE- (Bs As)'	)	;
INSERT INTO Localidades values	(	2804	, 'CAMPANA- (Bs As)'	)	;
INSERT INTO Localidades values	(	2806	, 'LIMA  - (Bs As)'	)	;
INSERT INTO Localidades values	(	2812	, 'CAPILLA DEL SEÑOR- (Bs As)'	)	;
INSERT INTO Localidades values	(	2814	, 'LOS CARDALES - (Bs As)'	)	;
INSERT INTO Localidades values	(	2900	, 'SAN NICOLAS  - (Bs As)'	)	;
INSERT INTO Localidades values	(	2907	, 'CONESA- (Bs As)'	)	;
INSERT INTO Localidades values	(	2914	, 'VILLA RAMALLO- (Bs As)'	)	;
INSERT INTO Localidades values	(	2915	, 'RAMALLO- (Bs As)'	)	;
INSERT INTO Localidades values	(	2930	, 'SAN PEDRO - (Bs As)'	)	;
INSERT INTO Localidades values	(	2933	, 'PEREZ MILLAN - (Bs As)'	)	;
INSERT INTO Localidades values	(	2935	, 'SANTA  LUCIA - (Bs As)'	)	;
INSERT INTO Localidades values	(	2942	, 'BARADERO  - (Bs As)'	)	;
INSERT INTO Localidades values	(	6000	, 'JUNIN - (Bs As)'	)	;
INSERT INTO Localidades values	(	6003	, 'ASCENCION - (Bs As)'	)	;
INSERT INTO Localidades values	(	6005	, 'GENERAL ARENALES - (Bs As)'	)	;
INSERT INTO Localidades values	(	6007	, 'ARRIBEÑOS - (Bs As)'	)	;
INSERT INTO Localidades values	(	6015	, 'GENERAL VIAMONTE - (Bs As)'	)	;
INSERT INTO Localidades values	(	6030	, 'VEDIA - (Bs As)'	)	;
INSERT INTO Localidades values	(	6034	, 'JUAN B. ALBERDI  - (Bs As)'	)	;
INSERT INTO Localidades values	(	6050	, 'GENERAL PINTO- (Bs As)'	)	;
INSERT INTO Localidades values	(	6062	, 'CORONEL GRANADA  - (Bs As)'	)	;
INSERT INTO Localidades values	(	6064	, 'AMEGHINO  - (Bs As)'	)	;
INSERT INTO Localidades values	(	6065	, 'BLAQUIER  - (Bs As)'	)	;
INSERT INTO Localidades values	(	6070	, 'LINCOLN- (Bs As)'	)	;
INSERT INTO Localidades values	(	6075	, 'ROBERTS- (Bs As)'	)	;
INSERT INTO Localidades values	(	6077	, 'PASTEUR- (Bs As)'	)	;
INSERT INTO Localidades values	(	6220	, 'BERNARDO LARROUDE- (Bs As)'	)	;
INSERT INTO Localidades values	(	6223	, 'CHARLONE  - (Bs As)'	)	;
INSERT INTO Localidades values	(	6230	, 'GRAL VILLEGAS- (Bs As)'	)	;
INSERT INTO Localidades values	(	6231	, 'TRES ALGARROBOS  - (Bs As)'	)	;
INSERT INTO Localidades values	(	6237	, 'AMERICA- (Bs As)'	)	;
INSERT INTO Localidades values	(	6241	, 'E.  BUNGE - (Bs As)'	)	;
INSERT INTO Localidades values	(	6244	, 'BANDELALO - (Bs As)'	)	;
INSERT INTO Localidades values	(	6339	, 'SALLIQUELO- (Bs As)'	)	;
INSERT INTO Localidades values	(	6346	, 'PELLEGRINI- (Bs As)'	)	;
INSERT INTO Localidades values	(	6400	, 'TRENQUE LAUQUEN  - (Bs As)'	)	;
INSERT INTO Localidades values	(	6405	, '30 DE AGOSTO - (Bs As)'	)	;
INSERT INTO Localidades values	(	6409	, 'TRES LOMAS- (Bs As)'	)	;
INSERT INTO Localidades values	(	6417	, 'CASBAS- (Bs As)'	)	;
INSERT INTO Localidades values	(	6430	, 'CARHUE- (Bs As)'	)	;
INSERT INTO Localidades values	(	6435	, 'GUAMINI- (Bs As)'	)	;
INSERT INTO Localidades values	(	6441	, 'RIVERA- (Bs As)'	)	;
INSERT INTO Localidades values	(	6450	, 'PEHUAJO- (Bs As)'	)	;
INSERT INTO Localidades values	(	6455	, 'C. TEJEDOR- (Bs As)'	)	;
INSERT INTO Localidades values	(	6465	, 'HENDERSON - (Bs As)'	)	;
INSERT INTO Localidades values	(	6471	, 'SALAZAR- (Bs As)'	)	;
INSERT INTO Localidades values	(	6474	, 'JUAN JOSE PASO- (Bs As)'	)	;
INSERT INTO Localidades values	(	6500	, '9 DE JULIO- (Bs As)'	)	;
INSERT INTO Localidades values	(	6530	, 'CARLOS CASARES- (Bs As)'	)	;
INSERT INTO Localidades values	(	6533	, 'QUIROGA- (Bs As)'	)	;
INSERT INTO Localidades values	(	6550	, 'BOLIVAR- (Bs As)'	)	;
INSERT INTO Localidades values	(	6555	, 'DAIREAUX  - (Bs As)'	)	;
INSERT INTO Localidades values	(	6600	, 'MERCEDES  - (Bs As)'	)	;
INSERT INTO Localidades values	(	6605	, 'NAVARRO- (Bs As)'	)	;
INSERT INTO Localidades values	(	6612	, 'SUIPACHA  - (Bs As)'	)	;
INSERT INTO Localidades values	(	6620	, 'CHIVILCOY - (Bs As)'	)	;
INSERT INTO Localidades values	(	6625	, 'MOQUEHUA  - (Bs As)'	)	;
INSERT INTO Localidades values	(	6634	, 'ALBERTI- (Bs As)'	)	;
INSERT INTO Localidades values	(	6640	, 'BRAGADO- (Bs As)'	)	;
INSERT INTO Localidades values	(	6646	, 'GENERAL O´BRIEN  - (Bs As)'	)	;
INSERT INTO Localidades values	(	6660	, '25 DE MAYO- (Bs As)'	)	;
INSERT INTO Localidades values	(	6663	, 'N. DE LA RIESTRA - (Bs As)'	)	;
INSERT INTO Localidades values	(	6700	, 'LUJAN - (Bs As)'	)	;
INSERT INTO Localidades values	(	6720	, 'SAN ANDRES DE GILES  - (Bs As)'	)	;
INSERT INTO Localidades values	(	6725	, 'CARMEN DE ARECO  - (Bs As)'	)	;
INSERT INTO Localidades values	(	6734	, 'RAWSON- (Bs As)'	)	;
INSERT INTO Localidades values	(	6740	, 'CHACABUCO - (Bs As)'	)	;
INSERT INTO Localidades values	(	6748	, 'O HIGGINS - (Bs As)'	)	;
INSERT INTO Localidades values	(	7000	, 'TANDIL- (Bs As)'	)	;
INSERT INTO Localidades values	(	7003	, 'M.  IGNACIA  - (Bs As)'	)	;
INSERT INTO Localidades values	(	7011	, 'J. N. FERNANDEZ  - (Bs As)'	)	;
INSERT INTO Localidades values	(	7020	, 'BENITO JUAREZ- (Bs As)'	)	;
INSERT INTO Localidades values	(	7100	, 'DOLORES- (Bs As)'	)	;
INSERT INTO Localidades values	(	7105	, 'SAN CLEMENTE DEL TUYU- (Bs As)'	)	;
INSERT INTO Localidades values	(	7107	, 'SANTA TERESISTA  - (Bs As)'	)	;
INSERT INTO Localidades values	(	7109	, 'MAR DE AJO- (Bs As)'	)	;
INSERT INTO Localidades values	(	7111	, 'SAN BERNARDO - (Bs As)'	)	;
INSERT INTO Localidades values	(	7114	, 'CASTELLI  - (Bs As)'	)	;
INSERT INTO Localidades values	(	7116	, 'PILA  - (Bs As)'	)	;
INSERT INTO Localidades values	(	7130	, 'CHASCOMUS - (Bs As)'	)	;
INSERT INTO Localidades values	(	7150	, 'AYACUCHO  - (Bs As)'	)	;
INSERT INTO Localidades values	(	7160	, 'MAIPU - (Bs As)'	)	;
INSERT INTO Localidades values	(	7163	, 'GRAL. MADARIAGA  - (Bs As)'	)	;
INSERT INTO Localidades values	(	7165	, 'VILLA GESELL - (Bs As)'	)	;
INSERT INTO Localidades values	(	7167	, 'PINAMAR- (Bs As)'	)	;
INSERT INTO Localidades values	(	7200	, 'LAS FLORES- (Bs As)'	)	;
INSERT INTO Localidades values	(	7203	, 'RAUCH - (Bs As)'	)	;
INSERT INTO Localidades values	(	7214	, 'CACHARI- (Bs As)'	)	;
INSERT INTO Localidades values	(	7220	, 'S.M. DE  MONTE- (Bs As)'	)	;
INSERT INTO Localidades values	(	7223	, 'GENERAL BELGRANO - (Bs As)'	)	;
INSERT INTO Localidades values	(	7240	, 'LOBOS - (Bs As)'	)	;
INSERT INTO Localidades values	(	7249	, 'LOBOS - (Bs As)'	)	;
INSERT INTO Localidades values	(	7260	, 'SALADILLO - (Bs As)'	)	;
INSERT INTO Localidades values	(	7263	, 'GENERAL ALVEAR- (Bs As)'	)	;
INSERT INTO Localidades values	(	7300	, 'AZUL  - (Bs As)'	)	;
INSERT INTO Localidades values	(	7303	, 'TAPALQUE  - (Bs As)'	)	;
INSERT INTO Localidades values	(	7311	, 'CHILLAR- (Bs As)'	)	;
INSERT INTO Localidades values	(	7400	, 'OLAVARRIA - (Bs As)'	)	;
INSERT INTO Localidades values	(	7403	, 'LOMA NEGRA- (Bs As)'	)	;
INSERT INTO Localidades values	(	7406	, 'GENERAL LAMADRID - (Bs As)'	)	;
INSERT INTO Localidades values	(	7414	, 'LAPRIDA- (Bs As)'	)	;
INSERT INTO Localidades values	(	7500	, 'TRES ARROYOS - (Bs As)'	)	;
INSERT INTO Localidades values	(	7503	, 'ORENSE- (Bs As)'	)	;
INSERT INTO Localidades values	(	7509	, 'ORIENTE- (Bs As)'	)	;
INSERT INTO Localidades values	(	7515	, 'DE LA GARMA  - (Bs As)'	)	;
INSERT INTO Localidades values	(	7521	, 'SAN CAYETANO - (Bs As)'	)	;
INSERT INTO Localidades values	(	7530	, 'CORONEL PRINGLES - (Bs As)'	)	;
INSERT INTO Localidades values	(	7540	, 'CORONEL SUAREZ- (Bs As)'	)	;
INSERT INTO Localidades values	(	7545	, 'HUANGUELEN- (Bs As)'	)	;
INSERT INTO Localidades values	(	7600	, 'MAR DEL PLATA - (Bs As)'	)	;
INSERT INTO Localidades values	(	7601	, 'BATAN - (Bs As)'	)	;
INSERT INTO Localidades values	(	7603	, 'CTE. N. OTAMENDI - (Bs As)'	)	;
INSERT INTO Localidades values	(	7605	, 'MECHONGUE - (Bs As)'	)	;
INSERT INTO Localidades values	(	7607	, 'MIRAMAR- (Bs As)'	)	;
INSERT INTO Localidades values	(	7620	, 'BALCARCE  - (Bs As)'	)	;
INSERT INTO Localidades values	(	7630	, 'NECOCHEA  - (Bs As)'	)	;
INSERT INTO Localidades values	(	7631	, 'QUEQUEN- (Bs As)'	)	;
INSERT INTO Localidades values	(	7635	, 'LOBERIA- (Bs As)'	)	;
INSERT INTO Localidades values	(	7637	, 'NICANOR OLIVERA  - (Bs As)'	)	;
INSERT INTO Localidades values	(	8000	, 'BAHIA BLANCA - (Bs As)'	)	;
INSERT INTO Localidades values	(	8103	, 'INGENIERO  WHITE - (Bs As)'	)	;
INSERT INTO Localidades values	(	8109	, 'PUNTA ALTA- (Bs As)'	)	;
INSERT INTO Localidades values	(	8118	, 'CABILDO- (Bs As)'	)	;
INSERT INTO Localidades values	(	8132	, 'MEDANOS- (Bs As)'	)	;
INSERT INTO Localidades values	(	8136	, 'JUAN COUSTE  - (Bs As)'	)	;
INSERT INTO Localidades values	(	8146	, 'M. BURATOVICH - (Bs As)'	)	;
INSERT INTO Localidades values	(	8148	, 'PEDRO LURO- (Bs As)'	)	;
INSERT INTO Localidades values	(	8150	, 'CORONEL DORREGO  - (Bs As)'	)	;
INSERT INTO Localidades values	(	8153	, 'MONTE HERMOSO - (Bs As)'	)	;
INSERT INTO Localidades values	(	8160	, 'TORNQUIST - (Bs As)'	)	;
INSERT INTO Localidades values	(	8170	, 'PIGUE - (Bs As)'	)	;
INSERT INTO Localidades values	(	8180	, 'PUAN  - (Bs As)'	)	;
INSERT INTO Localidades values	(	8183	, 'DARREGUEIRA  - (Bs As)'	)	;
INSERT INTO Localidades values	(	8504	, 'C. DE PATAGONES  - (Bs As)'	)	;
INSERT INTO Localidades values	(	8508	, 'STROEDER  - (Bs As)'	)	;
INSERT INTO Localidades values	(	8512	, 'VILLALONGA- (Bs As)'	)	;
INSERT INTO Localidades values	(	11408	, 'AV. RIVADAVIA 11102  - (Bs As)'	)	;
INSERT INTO Localidades values	(	11425	, 'AV. SANTA FE 3960- (Bs As)'	)	;
INSERT INTO Localidades values	(	11426	, 'F. LACROZE  2668 - (Bs As)'	)	;
INSERT INTO Localidades values	(	11437	, 'POMPEYA- (Bs As)'	)	;
INSERT INTO Localidades values	(	11605	, 'CARAPACHAY- (Bs As)'	)	;
INSERT INTO Localidades values	(	11636	, 'LA LUCILA - (Bs As)'	)	;
INSERT INTO Localidades values	(	11638	, 'ARISTOBULO DEL VALLE - (Bs As)'	)	;
INSERT INTO Localidades values	(	11646	, 'VIRREYES  - (Bs As)'	)	;
INSERT INTO Localidades values	(	11650	, 'VILLA MAIPU  - (Bs As)'	)	;
INSERT INTO Localidades values	(	11657	, 'Pablo Podesta Pdo 3 d Feb	(Bs As)'	)	;
INSERT INTO Localidades values	(	11672	, 'VILLA  LYNCH - (Bs As)'	)	;
INSERT INTO Localidades values	(	11676	, 'SANTOS LUGARES- (Bs As)'	)	;
INSERT INTO Localidades values	(	11682	, 'PABLO PODESTA - (Bs As)'	)	;
INSERT INTO Localidades values	(	11686	, 'WILLIAMS  C.  MORRIS - (Bs As)'	)	;
INSERT INTO Localidades values	(	11702	, 'JOSE INGENIEROS  - (Bs As)'	)	;
INSERT INTO Localidades values	(	11706	, 'HAEDO NORTE  - (Bs As)'	)	;
INSERT INTO Localidades values	(	11718	, 'MERLO - (Bs As)'	)	;
INSERT INTO Localidades values	(	11722	, 'PARQUE SAN MARTIN- (Bs As)'	)	;
INSERT INTO Localidades values	(	11752	, 'VILLA INSUPERABLE- (Bs As)'	)	;
INSERT INTO Localidades values	(	11770	, 'TAPIALES  - (Bs As)'	)	;
INSERT INTO Localidades values	(	11771	, 'AUT. RICHIERI y BOUL.SUR 	(Bs As)'	)	;
INSERT INTO Localidades values	(	11826	, 'LANUS ESTE- (Bs As)'	)	;
INSERT INTO Localidades values	(	11834	, 'TURDERA- (Bs As)'	)	;
INSERT INTO Localidades values	(	11870	, 'PIÑEYRO- (Bs As)'	)	;
INSERT INTO Localidades values	(	11878	, 'AVELLANEDA- (Bs As)'	)	;
INSERT INTO Localidades values	(	11900	, 'TOLOSA- (Bs As)'	)	;
INSERT INTO Localidades values	(	11901	, 'RINQUELET - LA PLATA - (Bs As)'	)	;
INSERT INTO Localidades values	(	16241	, 'PIEDRITAS - (Bs As)'	)	;
INSERT INTO Localidades values	(	16533	, 'MARTINEZ DE HOZ  - (Bs As)'	)	;
INSERT INTO Localidades values	(	21408	, 'LINIERS- (Bs As)'	)	;
INSERT INTO Localidades values	(	21605	, 'CARAPACHAY- (Bs As)'	)	;
INSERT INTO Localidades values	(	21706	, 'RIVADAVIA 15956 (HAEDO) - (Bs As)'	)	;
INSERT INTO Localidades values	(	21752	, 'LA MATANZA- (Bs As)'	)	;
INSERT INTO Localidades values	(	21870	, 'GERLI - (Bs As)'	)	;
INSERT INTO Localidades values	(	21900	, 'LOS  HORNOS  - (Bs As)'	)	;
INSERT INTO Localidades values	(	31440	, 'MATADEROS - (Bs As)'	)	;
INSERT INTO Localidades values	(	41426	, 'BUENOS AIRES - (Bs As)'	)	;


INSERT INTO Localidades values	(	4190	,'ROSARIO DE LA FRONTERA - SALTA ')	;
INSERT INTO Localidades values	(	4400	,'SALTA- SALTA ')	;
INSERT INTO Localidades values	(	4403	,'CERRILLOS - SALTA ')	;
INSERT INTO Localidades values	(	4405	,'ROSARIO DE LERMA - SALTA ')	;
INSERT INTO Localidades values	(	4417	,'CACHI - SALTA ')	;
INSERT INTO Localidades values	(	4421	,'LA MERCED - SALTA ')	;
INSERT INTO Localidades values	(	4423	,'CHICUANA - SALTA ')	;
INSERT INTO Localidades values	(	4427	,'CAFAYATE - SALTA ')	;
INSERT INTO Localidades values	(	4430	,'GENERAL GÜEMES - SALTA ')	;
INSERT INTO Localidades values	(	4440	,'METAN- SALTA ')	;
INSERT INTO Localidades values	(	4444	,'EL GALPON - SALTA ')	;
INSERT INTO Localidades values	(	4448	,'JOAQUIN V. GONZALEZ - SALTA ')	;
INSERT INTO Localidades values	(	4449	,'APOLINARIO SARAVIA - SALTA ')	;
INSERT INTO Localidades values	(	4452	,'EL QUEBRACHAL- SALTA ')	;
INSERT INTO Localidades values	(	4530	,'ORAN - SALTA ')	;
INSERT INTO Localidades values	(	4531	,'COLONIA SANTA ROSA- SALTA ')	;
INSERT INTO Localidades values	(	4533	,'HIPOLITO IRIGOYEN - SALTA ')	;
INSERT INTO Localidades values	(	4550	,'EMBARCACION- SALTA ')	;
INSERT INTO Localidades values	(	4560	,'TARTAGAL- SALTA ')	;
INSERT INTO Localidades values	(	4562	,'GENERAL MOSCONI - SALTA ')	;
INSERT INTO Localidades values	(	4568	,'PROF. SALVADOR MAZZA - SALTA ')	;
INSERT INTO Localidades values	(	14421	,'CORONEL MOLDES- SALTA ')	;
INSERT INTO Localidades values	(	14449	,'LAS LAJITAS- SALTA ')	;
INSERT INTO Localidades values	(	14534	,'PICHANAL- SALTA ')	;
INSERT INTO Localidades values	(	14568	,'SALVADORMAZZA - SALTA ')	;
INSERT INTO Localidades values	(	24534	,'SANTA ROSA- SALTA ')	;

INSERT INTO Localidades values	(	1	, 'CAPITAL FEDERAL - (CAPITAL FEDERAL) '	)	;
INSERT INTO Localidades values	(	11	, 'CAPITAL FEDERAL - (CAPITAL FEDERAL) '	)	;
INSERT INTO Localidades values	(	1001	, 'PARQUE PATRICIOS- (CAPITAL FEDERAL) '	)	;
INSERT INTO Localidades values	(	1002	, 'BUENOS AIRES - (CAPITAL FEDERAL) '	)	;
INSERT INTO Localidades values	(	1006	, 'MAIPU   316  - (CAPITAL FEDERAL) '	)	;
INSERT INTO Localidades values	(	1007	, 'CAPITAL FEDERAL - (CAPITAL FEDERAL) '	)	;
INSERT INTO Localidades values	(	1010	, 'CERRITO  370 - (CAPITAL FEDERAL) '	)	;
INSERT INTO Localidades values	(	1011	, 'CARLOS PELLEGRINI  1391 - (CAPITAL FEDERAL) '	)	;
INSERT INTO Localidades values	(	1013	, 'TALCAHUANO    459  - (CAPITAL FEDERAL) '	)	;
INSERT INTO Localidades values	(	1014	, 'AV. PTE. QUINTANA  111  - (CAPITAL FEDERAL) '	)	;
INSERT INTO Localidades values	(	1016	, 'URUGUAY  1031- (CAPITAL FEDERAL) '	)	;
INSERT INTO Localidades values	(	1019	, 'CAPITAL FEDERAL - (CAPITAL FEDERAL) '	)	;
INSERT INTO Localidades values	(	1022	, 'CALLAO  101  - (CAPITAL FEDERAL) '	)	;
INSERT INTO Localidades values	(	1023	, 'AVDA. CALLAO  1171 - (CAPITAL FEDERAL) '	)	;
INSERT INTO Localidades values	(	1024	, 'LAS HERAS  2033 - (CAPITAL FEDERAL) '	)	;
INSERT INTO Localidades values	(	1031	, 'CAPITAL FEDERAL - (CAPITAL FEDERAL) '	)	;
INSERT INTO Localidades values	(	1032	, 'AV. PUYRREDON  218 - (CAPITAL FEDERAL) '	)	;
INSERT INTO Localidades values	(	1034	, 'AV. RIVADAVIA  2330- (CAPITAL FEDERAL) '	)	;
INSERT INTO Localidades values	(	1036	, 'BARTOLOME MITRE  800 - (CAPITAL FEDERAL) '	)	;
INSERT INTO Localidades values	(	1037	, 'CAPITAL FEDERAL - (CAPITAL FEDERAL) '	)	;
INSERT INTO Localidades values	(	1041	, 'SARMIENTO  401  - (CAPITAL FEDERAL) '	)	;
INSERT INTO Localidades values	(	1042	, 'LA PAMPA  2010  - (CAPITAL FEDERAL) '	)	;
INSERT INTO Localidades values	(	1043	, 'CAPITAL FEDERAL - (CAPITAL FEDERAL) '	)	;
INSERT INTO Localidades values	(	1044	, 'CAPITAL FEDERAL - (CAPITAL FEDERAL) '	)	;
INSERT INTO Localidades values	(	1046	, 'AV.CORRIENTES 2267 - (CAPITAL FEDERAL) '	)	;
INSERT INTO Localidades values	(	1047	, 'CAPITAL  FEDERAL- (CAPITAL FEDERAL) '	)	;
INSERT INTO Localidades values	(	1048	, 'LAVALLE  1402- (CAPITAL FEDERAL) '	)	;
INSERT INTO Localidades values	(	1049	, 'CAPITAL FEDERAL - (CAPITAL FEDERAL) '	)	;
INSERT INTO Localidades values	(	1053	, 'BUENOS AIRES - (CAPITAL FEDERAL) '	)	;
INSERT INTO Localidades values	(	1054	, 'AVDA. CORDOBA 930/34 - (CAPITAL FEDERAL) '	)	;
INSERT INTO Localidades values	(	1055	, 'AVDA. CORDOBA   1527BS.AS- (CAPITAL FEDERAL) '	)	;
INSERT INTO Localidades values	(	1057	, 'CAPITAL FEDERAL - (CAPITAL FEDERAL) '	)	;
INSERT INTO Localidades values	(	1058	, 'CAPITAL FEDERAL - (CAPITAL FEDERAL) '	)	;
INSERT INTO Localidades values	(	1059	, 'MARTIN CORONADO - (CAPITAL FEDERAL) '	)	;
INSERT INTO Localidades values	(	1062	, 'JUNCAL  735  - (CAPITAL FEDERAL) '	)	;
INSERT INTO Localidades values	(	1065	, 'HIPOLITO IRIGOYEN   402 - (CAPITAL FEDERAL) '	)	;
INSERT INTO Localidades values	(	1071	, 'TACUARI   83 - (CAPITAL FEDERAL) '	)	;
INSERT INTO Localidades values	(	1072	, 'CONSTITUCION - (CAPITAL FEDERAL) '	)	;
INSERT INTO Localidades values	(	1085	, 'AV. DE MAYO  1225  - (CAPITAL FEDERAL) '	)	;
INSERT INTO Localidades values	(	1086	, 'AV. HIPOLITO YRIGOYEN 402- (CAPITAL FEDERAL) '	)	;
INSERT INTO Localidades values	(	1093	, 'AV. BELGRANO  1668 - (CAPITAL FEDERAL) '	)	;
INSERT INTO Localidades values	(	1094	, 'MORENO  2400 - (CAPITAL FEDERAL) '	)	;
INSERT INTO Localidades values	(	1098	, 'CAPITAL FEDERAL - (CAPITAL FEDERAL) '	)	;
INSERT INTO Localidades values	(	1103	, 'CAPITAL FEDERAL - (CAPITAL FEDERAL) '	)	;
INSERT INTO Localidades values	(	1119	, 'CAPITAL FEDERAL - (CAPITAL FEDERAL) '	)	;
INSERT INTO Localidades values	(	1138	, 'BERNARDO HIRIGOYEN 1340 - (CAPITAL FEDERAL) '	)	;
INSERT INTO Localidades values	(	1155	, 'CAPITAL FEDERAL - (CAPITAL FEDERAL) '	)	;
INSERT INTO Localidades values	(	1169	, 'CAPITAL FEDERAL - (CAPITAL FEDERAL) '	)	;
INSERT INTO Localidades values	(	1173	, 'CAPITAL FEDERAL - (CAPITAL FEDERAL) '	)	;
INSERT INTO Localidades values	(	1193	, 'AV. CORRIENTES 3158- (CAPITAL FEDERAL) '	)	;
INSERT INTO Localidades values	(	1194	, 'AV. CORRIENTES y  MEDRANO- (CAPITAL FEDERAL) '	)	;
INSERT INTO Localidades values	(	1195	, 'CORRIENTES AVDA.- (CAPITAL FEDERAL) '	)	;
INSERT INTO Localidades values	(	1208	, 'CAPITAL FEDERAL - (CAPITAL FEDERAL) '	)	;
INSERT INTO Localidades values	(	1210	, 'CAPITAL FEDERAL - (CAPITAL FEDERAL) '	)	;
INSERT INTO Localidades values	(	1218	, 'AVDA. BOEDO  - (CAPITAL FEDERAL) '	)	;
INSERT INTO Localidades values	(	1225	, 'GREGORIO PALOMAR- (CAPITAL FEDERAL) '	)	;
INSERT INTO Localidades values	(	1226	, 'MEXICO   3091- (CAPITAL FEDERAL) '	)	;
INSERT INTO Localidades values	(	1232	, 'AV. SAN JUAN 2496  - (CAPITAL FEDERAL) '	)	;
INSERT INTO Localidades values	(	1235	, 'ALMAGRO - (CAPITAL FEDERAL) '	)	;
INSERT INTO Localidades values	(	1255	, 'CAPITAL FEDERAL - (CAPITAL FEDERAL) '	)	;
INSERT INTO Localidades values	(	1264	, 'AV. CASEROS 2898- (CAPITAL FEDERAL) '	)	;
INSERT INTO Localidades values	(	1265	, 'AV. R. DE LOS PATRICIOS - (CAPITAL FEDERAL) '	)	;
INSERT INTO Localidades values	(	1269	, 'ISABEL LA CATOLICA - (CAPITAL FEDERAL) '	)	;
INSERT INTO Localidades values	(	1285	, 'AV. VELEZ SARSFIELD  1847 - (CAPITAL FEDERAL) '	)	;
INSERT INTO Localidades values	(	1309	, 'CERRITO  740/748- (CAPITAL FEDERAL) '	)	;
INSERT INTO Localidades values	(	1314	, 'CAPITAL FEDERAL - (CAPITAL FEDERAL) '	)	;
INSERT INTO Localidades values	(	1360	, 'MICROCENTRO SAN MARTIN  - (CAPITAL FEDERAL) '	)	;
INSERT INTO Localidades values	(	1399	, 'AVDA. PASEO COLON  367  - (CAPITAL FEDERAL) '	)	;
INSERT INTO Localidades values	(	1405	, 'AV. GAONA  1170/80 - (CAPITAL FEDERAL) '	)	;
INSERT INTO Localidades values	(	1408	, 'CAPITAL FEDERAL - (CAPITAL FEDERAL) '	)	;
INSERT INTO Localidades values	(	1426	, 'VIRGILIO  1774  - (CAPITAL FEDERAL) '	)	;
INSERT INTO Localidades values	(	1430	, 'TRONADOR  4102  - (CAPITAL FEDERAL) '	)	;
INSERT INTO Localidades values	(	1688	, 'V. TESEI- (CAPITAL FEDERAL) '	)	;
INSERT INTO Localidades values	(	1872	, 'SARANDI - (CAPITAL FEDERAL) '	)	;
INSERT INTO Localidades values	(	11005	, 'BRASIL   S/N - (CAPITAL FEDERAL) '	)	;
INSERT INTO Localidades values	(	11024	, 'AV. CALLAO  1140- (CAPITAL FEDERAL) '	)	;
INSERT INTO Localidades values	(	11036	, 'PLAZA DE MAYO- (CAPITAL FEDERAL) '	)	;
INSERT INTO Localidades values	(	11038	, 'DR. RICARDO ROJAS 401- (CAPITAL FEDERAL) '	)	;
INSERT INTO Localidades values	(	11046	, 'PARAGUAY  3535  - (CAPITAL FEDERAL) '	)	;
INSERT INTO Localidades values	(	11059	, 'ANCHORENA  845  - (CAPITAL FEDERAL) '	)	;
INSERT INTO Localidades values	(	11133	, 'AV. JUAN DE GARAY  2309 - (CAPITAL FEDERAL) '	)	;
INSERT INTO Localidades values	(	11270	, 'CAPITAL FEDERAL - (CAPITAL FEDERAL) '	)	;
INSERT INTO Localidades values	(	11414	, 'AVDA. CORDOBA  4502- (CAPITAL FEDERAL) '	)	;
INSERT INTO Localidades values	(	11424	, 'CABALLITO - (CAPITAL FEDERAL) '	)	;
INSERT INTO Localidades values	(	11440	, 'CAPITAL FEDERAL - (CAPITAL FEDERAL) '	)	;
INSERT INTO Localidades values	(	21406	, 'AV. EVA PERON 2133 - (CAPITAL FEDERAL) '	)	;
INSERT INTO Localidades values	(	21414	, 'CAPITAL FEDERAL - (CAPITAL FEDERAL) '	)	;
INSERT INTO Localidades values	(	21425	, 'AV. DEL LIBERTADOR 2196 - (CAPITAL FEDERAL) '	)	;
INSERT INTO Localidades values	(	21426	, 'AV. CABILDO  763- (CAPITAL FEDERAL) '	)	;
INSERT INTO Localidades values	(	31408	, 'RAMON L. FALCON  6837- (CAPITAL FEDERAL) '	)	;
INSERT INTO Localidades values	(	31425	, 'JERONIMO SALGUERO 3212  - (CAPITAL FEDERAL) '	)	;
INSERT INTO Localidades values	(	31426	, 'ARGERICH  4369  - (CAPITAL FEDERAL) '	)	;
INSERT INTO Localidades values	(	41408	, 'AV. EMILIO CASTRO  - (CAPITAL FEDERAL) '	)	;
INSERT INTO Localidades values	(	51425	, 'SALGUERO  2727/51  - (CAPITAL FEDERAL) '	)	;

INSERT INTO Localidades values	(	2	, 'NASCHET  - (SAN LUIS) '	)	;
INSERT INTO Localidades values	(	5131	, 'RANGEL- (SAN LUIS) '	)	;
INSERT INTO Localidades values	(	5700	, 'SAN LUIS - (SAN LUIS) '	)	;
INSERT INTO Localidades values	(	5705	, 'SAN FRANCISCO- (SAN LUIS) '	)	;
INSERT INTO Localidades values	(	5711	, 'QUINES- (SAN LUIS) '	)	;
INSERT INTO Localidades values	(	5713	, 'CANDELARIA - (SAN LUIS) '	)	;
INSERT INTO Localidades values	(	5719	, 'LA CALERA- (SAN LUIS) '	)	;
INSERT INTO Localidades values	(	5730	, 'VILLA MERCEDES  - (SAN LUIS) '	)	;
INSERT INTO Localidades values	(	5736	, 'FRAGA - (SAN LUIS) '	)	;
INSERT INTO Localidades values	(	5738	, 'JUSTO DARACT - (SAN LUIS) '	)	;
INSERT INTO Localidades values	(	5750	, 'LA TOMA  - (SAN LUIS) '	)	;
INSERT INTO Localidades values	(	5751	, 'SALADILLO- (SAN LUIS) '	)	;
INSERT INTO Localidades values	(	5770	, 'CONCARAN - (SAN LUIS) '	)	;
INSERT INTO Localidades values	(	5773	, 'TILISARAO- (SAN LUIS) '	)	;
INSERT INTO Localidades values	(	5777	, 'SANTA ROSA - (SAN LUIS) '	)	;
INSERT INTO Localidades values	(	5881	, 'MERLO - (SAN LUIS) '	)	;
INSERT INTO Localidades values	(	5883	, 'VILLA ELENA- (SAN LUIS) '	)	;
INSERT INTO Localidades values	(	6216	, 'UNION - (SAN LUIS) '	)	;
INSERT INTO Localidades values	(	6277	, 'BUENA ESPERANZA - (SAN LUIS) '	)	;
INSERT INTO Localidades values	(	6389	, 'ARIZONA  - (SAN LUIS) '	)	;
INSERT INTO Localidades values	(	14600	, 'TRAPICHE - (SAN LUIS) '	)	;
INSERT INTO Localidades values	(	14650	, 'EL MORRO - (SAN LUIS) '	)	;
INSERT INTO Localidades values	(	16216	, 'NUEVA GALIA- (SAN LUIS) '	)	;
INSERT INTO Localidades values	(	34000	, 'EL TRAPICHE- (SAN LUIS) '	)	;
INSERT INTO Localidades values	(	41425	, 'COLON - (SAN LUIS) '	)	;
INSERT INTO Localidades values	(	74000	, 'EL SUYUQUE - (SAN LUIS) '	)	;
INSERT INTO Localidades values	(	76000	, 'LA TOMA  - (SAN LUIS) '	)	;


INSERT INTO Localidades values	(	5759	,'NASCHEL - (LA PAMPA) '	)	;
INSERT INTO Localidades values	(	6200	,'REALICO - (LA PAMPA) '	)	;
INSERT INTO Localidades values	(	6203	,'EMBAJADOR MARTINI - (LA PAMPA) '	)	;
INSERT INTO Localidades values	(	6205	,'INGENIERO LUIGGI- (LA PAMPA) '	)	;
INSERT INTO Localidades values	(	6207	,'ALTA ITALIA - (LA PAMPA) '	)	;
INSERT INTO Localidades values	(	6221	,'INT. ALVEAR - (LA PAMPA) '	)	;
INSERT INTO Localidades values	(	6300	,'SANTA ROSA- (LA PAMPA) '	)	;
INSERT INTO Localidades values	(	6301	,'MIGUEL RIGLOS - (LA PAMPA) '	)	;
INSERT INTO Localidades values	(	6307	,'MACACHIN- (LA PAMPA) '	)	;
INSERT INTO Localidades values	(	6311	,'GRAL. M. J. CAMPOS- (LA PAMPA) '	)	;
INSERT INTO Localidades values	(	6313	,'WINIFREDA - (LA PAMPA) '	)	;
INSERT INTO Localidades values	(	6315	,'COLONIA BARON - (LA PAMPA) '	)	;
INSERT INTO Localidades values	(	6319	,'VICTORICA - (LA PAMPA) '	)	;
INSERT INTO Localidades values	(	6330	,'CATRILO - (LA PAMPA) '	)	;
INSERT INTO Localidades values	(	6333	,'QUEMU QUEMU - (LA PAMPA) '	)	;
INSERT INTO Localidades values	(	6360	,'GENERAL PICO- (LA PAMPA) '	)	;
INSERT INTO Localidades values	(	6367	,'METILEO - (LA PAMPA) '	)	;
INSERT INTO Localidades values	(	6369	,'TRENEL- (LA PAMPA) '	)	;
INSERT INTO Localidades values	(	6380	,'EDUARDO CASTEX- (LA PAMPA) '	)	;
INSERT INTO Localidades values	(	6385	,'ARATA - (LA PAMPA) '	)	;
INSERT INTO Localidades values	(	6387	,'CALEUFU - (LA PAMPA) '	)	;
INSERT INTO Localidades values	(	7245	,'ROQUE PEREZ - (LA PAMPA) '	)	;
INSERT INTO Localidades values	(	8200	,'GENERAL ACHA- (LA PAMPA) '	)	;
INSERT INTO Localidades values	(	8201	,'25 DE MAYO- (LA PAMPA) '	)	;
INSERT INTO Localidades values	(	8204	,'BERNASCONI- (LA PAMPA) '	)	;
INSERT INTO Localidades values	(	8206	,'GRAL. SAN MARTIN- (LA PAMPA) '	)	;
INSERT INTO Localidades values	(	8208	,'JACINTOARAUZ- (LA PAMPA) '	)	;
INSERT INTO Localidades values	(	8324	,'CIPOLLETTI- (LA PAMPA) '	)	;
INSERT INTO Localidades values	(	16311	,'GUATRACHE - (LA PAMPA) '	)	;
INSERT INTO Localidades values	(	18138	,'LAADELA - (LA PAMPA) '	)	;


INSERT INTO Localidades values	(	2341	, 'COLONIAALPINA - (STGO DEL ESTERO)'	)	;
INSERT INTO Localidades values	(	2354	, 'SELVA - (STGO DEL ESTERO)'	)	;
INSERT INTO Localidades values	(	2356	, 'PINTO - (STGO DEL ESTERO)'	)	;
INSERT INTO Localidades values	(	3064	, 'BANDERA - (STGO DEL ESTERO)'	)	;
INSERT INTO Localidades values	(	3712	, 'PIRIPINTOS - (STGO DEL ESTERO)'	)	;
INSERT INTO Localidades values	(	3731	, 'SACHAYO - (STGO DEL ESTERO)'	)	;
INSERT INTO Localidades values	(	3740	, 'QUIMILI - (STGO DEL ESTERO)'	)	;
INSERT INTO Localidades values	(	3743	, 'TINTINA - (STGO DEL ESTERO)'	)	;
INSERT INTO Localidades values	(	3747	, 'CAMPO GALLO- (STGO DEL ESTERO)'	)	;
INSERT INTO Localidades values	(	3749	, 'LA CAÑADA- (STGO DEL ESTERO)'	)	;
INSERT INTO Localidades values	(	3752	, 'VILELAS - (STGO DEL ESTERO)'	)	;
INSERT INTO Localidades values	(	3760	, 'AÑATUYA - (STGO DEL ESTERO)'	)	;
INSERT INTO Localidades values	(	3763	, 'LOS JURIES - (STGO DEL ESTERO)'	)	;
INSERT INTO Localidades values	(	3773	, 'LOS JURIES - (STGO DEL ESTERO)'	)	;
INSERT INTO Localidades values	(	4184	, 'POZO HONDO - (STGO DEL ESTERO)'	)	;
INSERT INTO Localidades values	(	4197	, 'NUEVA ESPERANZA - (STGO DEL ESTERO)'	)	;
INSERT INTO Localidades values	(	4200	, 'SANTIAGO DEL ESTERO - (STGO DEL ESTERO)'	)	;
INSERT INTO Localidades values	(	4206	, 'SIMBOL- (STGO DEL ESTERO)'	)	;
INSERT INTO Localidades values	(	4208	, 'LORETO- (STGO DEL ESTERO)'	)	;
INSERT INTO Localidades values	(	4220	, 'LAS TERMAS DE RIO HONDO - (STGO DEL ESTERO)'	)	;
INSERT INTO Localidades values	(	4230	, 'FRIAS - (STGO DEL ESTERO)'	)	;
INSERT INTO Localidades values	(	4234	, 'LAVALLE - (STGO DEL ESTERO)'	)	;
INSERT INTO Localidades values	(	4238	, 'S.P. DE GUASAYAN- (STGO DEL ESTERO)'	)	;
INSERT INTO Localidades values	(	4300	, 'LA BANDA- (STGO DEL ESTERO)'	)	;
INSERT INTO Localidades values	(	4308	, 'BELTRAM - (STGO DEL ESTERO)'	)	;
INSERT INTO Localidades values	(	4312	, 'FORRES- (STGO DEL ESTERO)'	)	;
INSERT INTO Localidades values	(	4313	, 'BREA POZO- (STGO DEL ESTERO)'	)	;
INSERT INTO Localidades values	(	4317	, 'VILLA ATAMISQUI - (STGO DEL ESTERO)'	)	;
INSERT INTO Localidades values	(	4321	, 'LOS TELARES- (STGO DEL ESTERO)'	)	;
INSERT INTO Localidades values	(	4322	, 'FERNANDEZ- (STGO DEL ESTERO)'	)	;
INSERT INTO Localidades values	(	4324	, 'GARZA - (STGO DEL ESTERO)'	)	;
INSERT INTO Localidades values	(	4326	, 'LUGONES - (STGO DEL ESTERO)'	)	;
INSERT INTO Localidades values	(	4328	, 'HERRERA - (STGO DEL ESTERO)'	)	;
INSERT INTO Localidades values	(	4332	, 'COLONIA DORA - (STGO DEL ESTERO)'	)	;
INSERT INTO Localidades values	(	4334	, 'ICAÑO - (STGO DEL ESTERO)'	)	;
INSERT INTO Localidades values	(	4338	, 'CLODOMIRA- (STGO DEL ESTERO)'	)	;
INSERT INTO Localidades values	(	4350	, 'SUNCHO CORRAL- (STGO DEL ESTERO)'	)	;
INSERT INTO Localidades values	(	5250	, 'OJO DE AGUA- (STGO DEL ESTERO)'	)	;
INSERT INTO Localidades values	(	5253	, 'SUMAMPA - (STGO DEL ESTERO)'	)	;
INSERT INTO Localidades values	(	12354	, 'MALBRAN - (STGO DEL ESTERO)'	)	;
INSERT INTO Localidades values	(	13712	, 'PAMPA DE LOS GUANACOS - (STGO DEL ESTERO)'	)	;
INSERT INTO Localidades values	(	14200	, 'Bº PALOMAR (SANTIAGO CAP - (STGO DEL ESTERO)'	)	;
INSERT INTO Localidades values	(	14324	, 'TABOADA - (STGO DEL ESTERO)'	)	;
INSERT INTO Localidades values	(	14334	, 'REAL SAYANA- (STGO DEL ESTERO)'	)	;



INSERT INTO Localidades values	(	2000	,'ROSARIO-(SANTA FE)'	)	;
INSERT INTO Localidades values	(	2005	,'ROSARIO-(SANTA FE)'	)	;
INSERT INTO Localidades values	(	2103	,'JUAN B. MOLINA-(SANTA FE)'	)	;
INSERT INTO Localidades values	(	2105	,'SARGENTO CABRAL -(SANTA FE)'	)	;
INSERT INTO Localidades values	(	2109	,'ACEBAL -(SANTA FE)'	)	;
INSERT INTO Localidades values	(	2111	,'SANTA TERESA-(SANTA FE)'	)	;
INSERT INTO Localidades values	(	2113	,'PEYRANO-(SANTA FE)'	)	;
INSERT INTO Localidades values	(	2114	,'ALVAREZ-(SANTA FE)'	)	;
INSERT INTO Localidades values	(	2115	,'MAXIMO PAZ-(SANTA FE)'	)	;
INSERT INTO Localidades values	(	2117	,'ALCORTA-(SANTA FE)'	)	;
INSERT INTO Localidades values	(	2121	,'PEREZ-(SANTA FE)'	)	;
INSERT INTO Localidades values	(	2123	,'FUENTES-(SANTA FE)'	)	;
INSERT INTO Localidades values	(	2124	,'VILLA GDOR. GALVEZ -(SANTA FE)'	)	;
INSERT INTO Localidades values	(	2126	,'ALVEAR -(SANTA FE)'	)	;
INSERT INTO Localidades values	(	2128	,'ARROYO SECO -(SANTA FE)'	)	;
INSERT INTO Localidades values	(	2132	,'FUNES-(SANTA FE)'	)	;
INSERT INTO Localidades values	(	2133	,'PUJATO -(SANTA FE)'	)	;
INSERT INTO Localidades values	(	2134	,'ROLDAN -(SANTA FE)'	)	;
INSERT INTO Localidades values	(	2136	,'SAN JERONIMO DEL SAUCE -(SANTA FE)'	)	;
INSERT INTO Localidades values	(	2138	,'CARCARAÑA-(SANTA FE)'	)	; */
