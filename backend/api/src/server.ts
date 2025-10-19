import Fastify from "fastify";
import cors from "@fastify/cors";
import dotenv from "dotenv";
import prismaPlugin from "./plugins/prisma";
dotenv.config();

const server = Fastify({ logger: true });

server.register(cors, { origin: "*" });
server.register(prismaPlugin);

// Simple health check route
server.get("/health", async () => {
  return { status: "ok", uptime: process.uptime() };
});

const start = async () => {
  try {
    const port = Number(process.env.PORT) || 3001;
    await server.listen({ port, host: "0.0.0.0" });
    console.log(`🚀 Server ready at http://localhost:${port}`);
  } catch (err) {
    server.log.error(err);
    process.exit(1);
  }
};

start();
