import express from "express";
import dotenv from "dotenv";

import antreanRouter from "@routes/antrean.route";
import pemeriksaanRouter from "@routes/pemeriksaan.route";
import kasirRouter from "@routes/kasir.route";
import reportRouter from "@routes/report.route";
import pasienRouter from "@routes/pasien.route";
import dokterRouter from "@routes/dokter.route";

dotenv.config();

const app = express();
const PORT = process.env.PORT || 3000;

app.use(express.json());

app.use("/api/v1/antrean", antreanRouter);
app.use("/api/v1/pemeriksaan", pemeriksaanRouter);
app.use("/api/v1/kasir", kasirRouter);
app.use("/api/v1/reports", reportRouter);
app.use("/api/v1/pasien", pasienRouter);
app.use("/api/v1/dokter", dokterRouter);


app.get("/", (_req, res) => {
  res.status(200).json({ status: "OK", message: "Smart Clinic API System is rum" });
});

app.listen(PORT, () => {
  console.log(`Server running on http://localhost:${PORT}`);
});