# Shared API Contract

All modules must use these endpoints.

## Public
POST /api/quotes/request
POST /api/quotes/calculate

## Leads
GET /api/leads
GET /api/leads/:id
PATCH /api/leads/:id/status
POST /api/leads/:id/notes
POST /api/leads/:id/assign

## AI
POST /api/ai/batch-analyze
GET /api/ai/recommendations
POST /api/ai/approve-message
POST /api/ai/reject-message

## Reports
GET /api/reports/daily

## Rules
- Use Supabase for database and authentication.
- Lead statuses: New, Quote Sent, Contacted, Follow-up Required, Negotiating, Converted, Dead, Nurture Later.
- No customer-facing AI message may be sent without approval.
- Every status change must create an audit record.
