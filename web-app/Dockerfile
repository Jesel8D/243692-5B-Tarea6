# Production image, copy all the files and run next
FROM node:20-alpine AS runner
WORKDIR /app

ENV NODE_ENV=production

# Don't run production as root
RUN addgroup --system --gid 1001 nodejs
RUN adduser --system --uid 1001 nextjs

COPY package*.json ./

# Install dependencies (only production to save space if needed, but here we kept simple ci)
RUN npm ci

COPY . .

# Set correct permissions
RUN chown -R nextjs:nodejs /app

# Switch to non-root user
USER nextjs

RUN npm run build

EXPOSE 3000

CMD ["npm", "start"]