import { read, write } from "pomljs";
import { readFile } from "node:fs/promises";

async function main() {
  const filePath = process.env.POML_FILE;
  if (!filePath) {
    throw new Error("POML_FILE is not set");
  }

  const pomlText = await readFile(filePath, "utf-8");
  const ir = await read(pomlText, undefined, {}, undefined, filePath);
  console.log(write(ir));
}

main().catch(console.error);
