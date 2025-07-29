# TEMPLATE PHÂN TÍCH TASK CHUYÊN NGHIỆP

## 📋 TASK ANALYSIS TEMPLATE

### THÔNG TIN CƠ BẢN
```markdown
**Task Title**: [Tên task]
**Assigned Date**: [Ngày nhận]
**Due Date**: [Deadline]
**Priority**: [High/Medium/Low]
**Stakeholder**: [PM/Team Lead/Client]
**Related Epic/Feature**: [Context lớn hơn]
```

### BƯỚC 1: REQUIREMENT ANALYSIS (30-60 phút)

#### 1.1 Business Context Questions
```markdown
❓ **WHY Questions**:
- Tại sao cần feature này?
- Business value là gì?
- User pain point nào được solve?
- Success metrics là gì?

❓ **WHO Questions**:
- Target users là ai?
- Stakeholders nào liên quan?
- Ai sẽ maintain code này?

❓ **WHAT Questions**:
- Exact requirements là gì?
- Acceptance criteria rõ ràng chưa?
- Out of scope là gì?
- Dependencies với features khác?

❓ **WHEN Questions**:
- Timeline thực tế là gì?
- Có milestones nào không?
- Blocking factors nào?

❓ **HOW Questions**:
- Technical approach nào phù hợp?
- Constraints gì cần consider?
- Performance requirements?
```

#### 1.2 Requirement Clarification Checklist
```markdown
- [ ] Functional requirements rõ ràng
- [ ] Non-functional requirements (performance, security, etc.)
- [ ] UI/UX mockups/wireframes available
- [ ] API specifications available
- [ ] Error handling requirements
- [ ] Testing requirements
- [ ] Browser/device compatibility
- [ ] Accessibility requirements
- [ ] Internationalization needs
```

### BƯỚC 2: TECHNICAL ANALYSIS (60-90 phút)

#### 2.1 Architecture Analysis
```markdown
**Current Architecture Review**:
- [ ] Existing patterns được sử dụng
- [ ] Similar features implementation
- [ ] Code structure và conventions
- [ ] State management approach
- [ ] API integration patterns

**Impact Analysis**:
- [ ] Components nào bị affect
- [ ] Breaking changes potential
- [ ] Database schema changes
- [ ] API changes needed
- [ ] Third-party integrations
```

#### 2.2 Technical Research
```markdown
**Packages/Libraries Research**:
- [ ] Existing packages có thể reuse
- [ ] New packages cần add
- [ ] Version compatibility
- [ ] License considerations
- [ ] Performance implications

**API Research**:
- [ ] Endpoints available
- [ ] Authentication requirements
- [ ] Rate limiting
- [ ] Error response formats
- [ ] Data validation rules
```

### BƯỚC 3: SOLUTION DESIGN (45-60 phút)

#### 3.1 High-Level Design
```markdown
**Architecture Diagram**:
```
[UI Layer]
    ↓
[State Management Layer]
    ↓
[Business Logic Layer]
    ↓
[Data Access Layer]
    ↓
[External APIs/Database]
```

**Component Breakdown**:
- Models: [List data models needed]
- Services: [List services needed]
- Providers/Controllers: [List state management]
- UI Components: [List UI components]
- Utils/Helpers: [List utility functions]
```

#### 3.2 Detailed Design
```markdown
**Data Flow**:
1. User action triggers...
2. UI calls provider method...
3. Provider calls service...
4. Service makes API call...
5. Response processed and state updated...
6. UI rebuilds with new state...

**Error Handling Strategy**:
- Network errors: [How to handle]
- Validation errors: [How to handle]
- Server errors: [How to handle]
- Unexpected errors: [How to handle]

**Loading States**:
- Initial loading: [Spinner, skeleton, etc.]
- Refresh loading: [Pull-to-refresh, etc.]
- Action loading: [Button loading, etc.]

**Caching Strategy**:
- What to cache: [Data types]
- Cache duration: [Time limits]
- Cache invalidation: [When to clear]
```

### BƯỚC 4: TASK BREAKDOWN & ESTIMATION

#### 4.1 Work Breakdown Structure
```markdown
**Phase 1: Foundation (X hours)**
- [ ] Data models creation
- [ ] API service setup
- [ ] Basic error handling
- [ ] Unit tests for models/services

**Phase 2: Business Logic (X hours)**
- [ ] State management implementation
- [ ] Business logic implementation
- [ ] Integration with existing services
- [ ] Unit tests for business logic

**Phase 3: UI Implementation (X hours)**
- [ ] Basic UI components
- [ ] State integration
- [ ] Loading states
- [ ] Error states
- [ ] Widget tests

**Phase 4: Integration & Polish (X hours)**
- [ ] End-to-end integration
- [ ] Edge cases handling
- [ ] Performance optimization
- [ ] Integration tests

**Phase 5: Testing & Documentation (X hours)**
- [ ] Comprehensive testing
- [ ] Code review preparation
- [ ] Documentation updates
- [ ] Demo preparation
```

#### 4.2 Risk Assessment
```markdown
**High Risk Items**:
- [ ] [Risk description] - Mitigation: [Plan]
- [ ] [Risk description] - Mitigation: [Plan]

**Medium Risk Items**:
- [ ] [Risk description] - Mitigation: [Plan]
- [ ] [Risk description] - Mitigation: [Plan]

**Dependencies**:
- [ ] External API availability
- [ ] Design assets completion
- [ ] Other team deliverables
- [ ] Third-party service setup
```

### BƯỚC 5: IMPLEMENTATION PLAN

#### 5.1 Development Approach
```markdown
**Development Strategy**:
- [ ] Bottom-up (Models → Services → UI)
- [ ] Top-down (UI → Services → Models)
- [ ] Feature-driven (Complete one feature at a time)

**Testing Strategy**:
- [ ] Test-driven development (TDD)
- [ ] Test after implementation
- [ ] Manual testing approach

**Code Review Strategy**:
- [ ] Self-review before submission
- [ ] Peer review process
- [ ] Senior review for complex parts
```

#### 5.2 Quality Gates
```markdown
**Definition of Done**:
- [ ] All acceptance criteria met
- [ ] Code follows project standards
- [ ] Unit tests written and passing
- [ ] Integration tests passing
- [ ] Code reviewed and approved
- [ ] Documentation updated
- [ ] No critical bugs
- [ ] Performance requirements met
```

### BƯỚC 6: COMMUNICATION PLAN

#### 6.1 Stakeholder Updates
```markdown
**Daily Updates**:
- Morning standup: Progress và blockers
- Slack updates: Significant milestones
- End of day: Summary và next day plan

**Weekly Updates**:
- Progress against timeline
- Risk updates
- Scope changes
- Quality metrics
```

#### 6.2 Questions for Team
```markdown
**Technical Questions**:
- [ ] [Specific technical question]
- [ ] [Architecture decision question]
- [ ] [Implementation approach question]

**Business Questions**:
- [ ] [Requirement clarification]
- [ ] [Priority question]
- [ ] [Scope question]
```

## 📊 TRACKING TEMPLATE

### Daily Progress Log
```markdown
**Date**: [Date]
**Planned Work**: [What you planned to do]
**Actual Work**: [What you actually did]
**Blockers**: [Any issues encountered]
**Next Steps**: [Tomorrow's plan]
**Questions**: [Questions for team]
```

### Weekly Review
```markdown
**Week of**: [Date range]
**Completed**: [List of completed items]
**In Progress**: [Current work]
**Blocked**: [Blocked items and reasons]
**Risks**: [New risks identified]
**Learnings**: [What you learned]
**Next Week Plan**: [Upcoming work]
```

## 🎯 EXAMPLE: REAL TASK ANALYSIS

### Task: "Implement Push Notification Settings Page"

#### Requirement Analysis
```markdown
**Business Context**: 
Users complain about too many notifications, need granular control

**User Story**: 
As a user, I want to customize notification preferences so that I only receive relevant notifications

**Acceptance Criteria**:
- [ ] Display all notification categories
- [ ] Toggle on/off for each category
- [ ] Save preferences to backend
- [ ] Sync across devices
- [ ] Show current status clearly
```

#### Technical Analysis
```markdown
**Existing Patterns**:
- Settings pages use SettingsProvider
- Toggle widgets use custom ToggleCard
- API calls use NotificationApiService

**New Components Needed**:
- NotificationSettingsModel
- NotificationSettingsProvider
- NotificationSettingsPage
- NotificationToggleCard widget

**API Integration**:
- GET /api/users/notification-settings
- PUT /api/users/notification-settings
```

#### Implementation Plan
```markdown
**Phase 1: Models & API (3 hours)**
- NotificationSettingsModel
- API service methods
- Unit tests

**Phase 2: State Management (2 hours)**
- NotificationSettingsProvider
- Business logic
- Unit tests

**Phase 3: UI Implementation (4 hours)**
- Settings page layout
- Toggle components
- Loading/error states
- Widget tests

**Phase 4: Integration (2 hours)**
- Navigation setup
- End-to-end testing
- Bug fixes

**Total Estimate: 11 hours**
```

---

**Lưu ý**: Template này có thể customize theo project và team requirements. Quan trọng là có systematic approach và không skip bất kỳ bước nào!