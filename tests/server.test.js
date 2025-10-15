const request = require("supertest");
const app = require("../src/server");

describe("Health endpoint", () => {
    it("should return ok", async () => {
        const res = await request(app).get("/health");
        expect(res.statusCode).toBe(200);
        expect(res.body.status).toBe("ok");
    });
});

describe("Echo endpoint", () => {
    it("should return echoed text", async () => {
        const res = await request(app).get("/echo?msg=hello");
        expect(res.statusCode).toBe(200);
        expect(res.text).toContain("hello");
    });
});
