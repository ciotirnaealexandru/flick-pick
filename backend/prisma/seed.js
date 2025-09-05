const { PrismaClient, Role } = require("@prisma/client");
const bcrypt = require("bcryptjs");

const prisma = new PrismaClient();

async function seedDatabase() {
  const users = [];

  console.log("Creating an ADMIN account");
  try {
    const res = await prisma.user.upsert({
      where: { email: "admin@gmail.com" },
      update: {},
      create: {
        email: "admin@gmail.com",
        firstName: "Admin First",
        lastName: "Admin Last",
        phone: "0000 000 000",
        password: await bcrypt.hash("admin", 12),
        role: Role.ADMIN,
      },
    });

    console.log("Inserted: ", res);
  } catch (error) {
    console.log("Error: ", error);
  }

  console.log("Creating USER accounts");
  try {
    for (let i = 1; i <= 10; i++) {
      const user = await prisma.user.upsert({
        where: { email: `user${i}@gmail.com` },
        update: {},
        create: {
          email: `user${i}@gmail.com`,
          firstName: `User_${i} First`,
          lastName: `User_${i} Last`,
          phone: `0000 000 000`,
          password: await bcrypt.hash("pass", 12),
          role: Role.USER,
        },
      });
      console.log("Inserted: ", user);
      users.push(user);
    }

    console.log("Database seeded successfully");
  } catch (error) {
    console.error("Error seeding database:", error);
  } finally {
    await prisma.$disconnect();
  }
}

// Execute the seeder
seedDatabase();
