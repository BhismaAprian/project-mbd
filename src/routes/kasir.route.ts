import { Router } from "express";
import { getTagihan, checkoutPembayaran, getPendapatanHariIni } from "@controllers/kasir.controller";

const router = Router();
router.get("/tagihan", getTagihan);
router.post("/bayar", checkoutPembayaran);
router.get("/pendapatan-hari-ini", getPendapatanHariIni);
export default router;