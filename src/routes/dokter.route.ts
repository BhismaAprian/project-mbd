import { Router } from "express";
import { getDokter } from "@controllers/dokter.controller";

const router = Router();

router.get("/", getDokter);

export default router;