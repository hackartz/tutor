/*menampilkan stok persuplier*/
select CONCAT(S.KODE,"-",S.NAMA) as Nama_Suplier,A.Qty,A.Nilai,A.Qty1,A.Nilai1,A.StokAkhir
from(
				select A.kode,A.suplier,A.Qty,A.Nilai ,B.Qty1,B.Nilai1,C.StokAkhir
				from(
									select left(TRANS.kode,2) as kode,suplier,sum(jumlah) as Qty,sum(jual*JUMLAH) as Nilai
									FROM TRANS WHERE (tanggal  BETWEEN  '2014-02-01' and '2014-02-22') and dari='TOKO' and target='PBELI' AND left(TRANS.kode,2)='22'
									GROUP BY SUPLIER 
				) A 
				LEFT JOIN(
									select left(TRANS.kode,2) as kode,suplier,sum(jumlah) as Qty1,sum(beli*JUMLAH) as Nilai1
									FROM TRANS WHERE (tanggal  BETWEEN  '2014-02-01' and '2014-02-22') and dari='' and target='GUDANG' AND left(TRANS.kode,2)='22'
									GROUP BY SUPLIER
				) B on A.suplier=B.suplier
				LEFT JOIN(
									select suplier,SUM(KODE.tk_akhir+KODE.gd_akhir) as StokAkhir
									FROM KODE
									GROUP BY SUPLIER
				) C on B.suplier=C.suplier
) A
INNER JOIN SUPLIER S ON A.suplier=S.KODE
