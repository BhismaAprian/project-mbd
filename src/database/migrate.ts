import { pool } from "../config/db";
import path from "path";

const migrationFiles = [
   "src/database/migrations/20260828_create_clinic_schema.sql",
   "src/database/migrations/20260828_seed_clinic_data.sql",
   "src/database/migrations/20260828_create_antrean_procedure_function.sql",
   "src/database/migrations/20260828_create_pemeriksaan_procedure_function.sql",
   "src/database/migrations/20260828_create_pembayaran_procedure_function.sql",
   "src/database/migrations/20260828_create_clinic_triggers.sql",
   "src/database/migrations/20260828_create_clinic_views.sql",
   "src/database/migrations/20260828_create_clinic_privileges.sql"
];

async function migrate() {
   try {
      console.log("Starting database migrations...\n");

      for (const filePath of migrationFiles) {
         const absolutePath = path.join(process.cwd(), filePath);
         const fileName = filePath.split("/").pop();
         
         console.log(`Executing: ${fileName}`);

         const file = Bun.file(absolutePath);
         if (!(await file.exists())) {
            throw new Error(`File missing: ${absolutePath}`);
         }

         const sqlContent = await file.text();
         await pool.query(sqlContent);

         console.log(`Sucess: ${fileName}\n`);
      }

      console.log("All migrations finished successfully!");
   } catch (error) {
      console.error("Migration failed:", error);
      process.exitCode = 1;
   } finally {
      await pool.end();
      process.exit();
   }
}

migrate();