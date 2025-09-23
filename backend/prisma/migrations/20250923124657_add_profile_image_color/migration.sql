-- CreateEnum
CREATE TYPE "public"."ProfileImageColor" AS ENUM ('RED', 'YELLOW', 'BLUE', 'PURPLE');

-- AlterTable
ALTER TABLE "public"."User" ADD COLUMN     "profileImageColor" "public"."ProfileImageColor" NOT NULL DEFAULT 'PURPLE';
