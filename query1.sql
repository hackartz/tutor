BEGIN

SET @SQLQUERY = "";
#mengambil bulan sekarang
SET @xblnskrg=(SELECT CONCAT(RIGHT(YEAR(curdate()),4),IF(LENGTH(MONTH(curdate()))=1,CONCAT('0',MONTH(curdate())),MONTH(curdate()))) AS N);
SET @BLNDARI=(SELECT CONCAT(RIGHT(YEAR(xtgldari),4),IF(LENGTH(MONTH(xtgldari))=1,CONCAT('0',MONTH(xtgldari)),MONTH(xtgldari))) AS N);
SET @BLNSAMPAI=(SELECT CONCAT(RIGHT(YEAR(xtglsampai),4),IF(LENGTH(MONTH(xtglsampai))=1,CONCAT('0',MONTH(xtglsampai)),MONTH(xtglsampai))) AS N);
SET @xblnmintadari=(SELECT CONCAT(RIGHT(YEAR(xtgldari),4),IF(LENGTH(MONTH(xtgldari))=1,CONCAT('0',MONTH(xtgldari)),MONTH(xtgldari))) AS N);
SET @xblnminta=(SELECT CONCAT(IF(LENGTH(MONTH(xtgldari))=1,CONCAT('0',MONTH(xtgldari)),MONTH(xtgldari)),RIGHT(YEAR(xtgldari),2)) AS N);
SET @xjmlbln=(SELECT PERIOD_DIFF(@BLNSAMPAI,@BLNDARI)+1 AS BEDA);
SET @cabang=(SELECT NAMACABANG FROM adagroup.cabanglist WHERE KDCABANG=xcabang AND AKTIF='Y');

IF @xblnmintadari=@xblnskrg THEN
    SET @xtblkode = 'KODE';
    SET @xtbltrans = 'TRANS';
ELSE
    SET @xtblkode = CONCAT('KODE',@xblnminta);
    SET @xtbltrans = CONCAT('TRAN',@xblnminta);
END IF;

set @cabangjadi = CONCAT(@cabang,".",@xtbltrans);
set @kodejadi = CONCAT(@cabang,".",@xtblkode);

SET @SQLQUERY = CONCAT(@SQLQUERY,"select CONCAT(S.KODE,'-',S.NAMA) as Nama_Suplier, ");
SET @SQLQUERY = CONCAT(@SQLQUERY,"SUM(CASE TRX WHEN 'SETIABUDIP' THEN qty ELSE 0 END) AS Qty_Jual, ");
SET @SQLQUERY = CONCAT(@SQLQUERY,"SUM(CASE TRX WHEN 'SETIABUDIP' THEN nilai ELSE 0 END) AS Nilai_Jual, ");
SET @SQLQUERY = CONCAT(@SQLQUERY,"SUM(CASE TRX WHEN 'SETIABUDIB' THEN qty ELSE 0 END) AS Qty_Beli, ");
SET @SQLQUERY = CONCAT(@SQLQUERY,"SUM(CASE TRX WHEN 'SETIABUDIB' THEN nilai ELSE 0 END) AS Nilai_Beli, ");
SET @SQLQUERY = CONCAT(@SQLQUERY,"SUM(CASE TRX WHEN 'SETIABUDITB' THEN qty ELSE 0 END) AS Qty_TotalAkhir, ");
SET @SQLQUERY = CONCAT(@SQLQUERY,"SUM(CASE TRX WHEN 'SETIABUDITB' THEN nilai ELSE 0 END) AS TotAkhir_Beli, ");
SET @SQLQUERY = CONCAT(@SQLQUERY,"SUM(CASE TRX WHEN 'SETIABUDITJ' THEN nilai ELSE 0 END) AS TotAkhir_Jual ");
SET @SQLQUERY = CONCAT(@SQLQUERY,"FROM( ");
SET @SQLQUERY = CONCAT(@SQLQUERY,"						select 'SETIABUDIP' AS TRX,left(",@cabangjadi,".kode,2) as kode,suplier,sum(jumlah) as qty,sum(jual*JUMLAH) as nilai ");
SET @SQLQUERY = CONCAT(@SQLQUERY,"						FROM ",@cabangjadi," WHERE (tanggal  BETWEEN   '",xtgldari,"' and '",xtglsampai,"') and dari='TOKO' and target='PBELI' AND left(",@cabangjadi,".kode,2)='",xdept,"' ");
SET @SQLQUERY = CONCAT(@SQLQUERY,"						GROUP BY SUPLIER ");
SET @SQLQUERY = CONCAT(@SQLQUERY,"						UNION ALL ");
SET @SQLQUERY = CONCAT(@SQLQUERY,"						select 'SETIABUDIB' AS TRX,left(",@cabangjadi,".kode,2) as kode,suplier,sum(jumlah) as qty,sum(beli*JUMLAH) as nilai ");
SET @SQLQUERY = CONCAT(@SQLQUERY,"						FROM ",@cabangjadi," WHERE (tanggal  BETWEEN  '",xtgldari,"' and '",xtglsampai,"') and dari='' and target='GUDANG' AND left(",@cabangjadi,".kode,2)='",xdept,"' ");
SET @SQLQUERY = CONCAT(@SQLQUERY,"						GROUP BY SUPLIER ");
SET @SQLQUERY = CONCAT(@SQLQUERY,"						UNION ALL ");
SET @SQLQUERY = CONCAT(@SQLQUERY,"						select 'SETIABUDITB' AS TRX,left(",@kodejadi,".kode,2),suplier,SUM(tk_akhir+gd_akhir) as qty,SUM(H_BELI * (tk_akhir+gd_akhir)) as nilai ");
SET @SQLQUERY = CONCAT(@SQLQUERY,"						FROM ",@kodejadi," WHERE left(KODE,2)='",xdept,"' ");
SET @SQLQUERY = CONCAT(@SQLQUERY,"						GROUP BY SUPLIER ");
SET @SQLQUERY = CONCAT(@SQLQUERY,"						UNION ALL ");
SET @SQLQUERY = CONCAT(@SQLQUERY,"						select 'SETIABUDITJ' AS TRX,left(",@kodejadi,".kode,2),suplier,SUM(tk_akhir+gd_akhir) as qty,SUM(H_JUAL * (tk_akhir+gd_akhir)) as nilai ");
SET @SQLQUERY = CONCAT(@SQLQUERY,"						FROM ",@kodejadi," WHERE left(KODE,2)='",xdept,"' ");
SET @SQLQUERY = CONCAT(@SQLQUERY,"						GROUP BY SUPLIER ");
SET @SQLQUERY = CONCAT(@SQLQUERY,") A INNER JOIN SUPLIER S ON A.suplier=S.KODE ");
SET @SQLQUERY = CONCAT(@SQLQUERY,"GROUP BY suplier ");
#select @SQLQUERY;
PREPARE STMT FROM @SQLQUERY;
EXECUTE STMT;


END
