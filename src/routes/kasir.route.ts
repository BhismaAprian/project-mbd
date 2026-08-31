import { Router } from "express";
import { getTagihan, checkoutPembayaran } from "@controllers/kasir.controller";

const router = Router();
router.get("/tagihan", getTagihan);
router.post("/bayar", checkoutPembayaran);

export default router;