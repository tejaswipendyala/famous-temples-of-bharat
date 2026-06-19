# Design Brief — Famous Temples of Bharat

## Purpose & Tone
Temple discovery platform for India. Warm, reverent, welcoming aesthetic inspired by temple courtyards — soft light, earthy tones, open breathing space. Accessible to all ages. Intentional restraint: no kitsch or ornate decoration.

## Visual Direction
Spiritual warmth through warm neutral palette (cream/ochre/terracotta) paired with generous whitespace. Gentle typography, layered elevation. Inspired by Indian temple architecture (curves, warmth, light) but executed with modern accessibility.

## Palette

| Token | Light | Dark | Usage |
|-------|-------|------|-------|
| Primary | `0.52 0.18 68` (warm ochre) | `0.72 0.14 70` (golden ochre) | CTAs, highlights, spiritual accent |
| Accent | `0.60 0.16 35` (terracotta) | `0.65 0.15 35` (warm rust) | Secondary highlights, category tags |
| Background | `0.96 0.02 65` (cream) | `0.16 0.02 45` (warm charcoal) | Page base |
| Foreground | `0.20 0.04 45` (deep warm brown) | `0.94 0.02 65` (cream) | Text |
| Card | `0.98 0.01 60` (off-white) | `0.20 0.02 50` (warm grey) | Temple cards, elevated surfaces |
| Muted | `0.88 0.04 60` (light warm) | `0.26 0.02 50` (dark grey) | Disabled, secondary content |

## Typography
- **Display**: Fraunces (serif, elegant, heritage-inspired for headings)
- **Body**: Figtree (warm, accessible, readable at all sizes)
- **Mono**: Geist Mono (functional, code/data)
- **Scale**: h1 3rem, h2 2rem, h3 1.5rem, body 1rem, small 0.875rem. Maintain `line-height: 1.6` for accessibility.

## Shape Language
`--radius: 0.75rem` (12px). Gentle roundness inspired by temple bells and domes. No sharp corners. Consistent across cards, buttons, inputs.

## Elevation & Shadows
- **warm-sm**: `0 1px 3px rgba(0,0,0,0.08)` — subtle separation
- **warm-md**: `0 4px 8px rgba(0,0,0,0.12)` — card elevation
- **warm-lg**: `0 8px 16px rgba(0,0,0,0.14)` — modals, popovers
No glows, gradients, or neon. All shadows use warm opacity values.

## Structural Zones

| Zone | Light Theme | Dark Theme | Detail |
|------|-------------|-----------|--------|
| Header | `bg-card border-b border-border` | `bg-card border-b border-border` | Primary accent text for logo. Warm card background for toolbar. |
| Main Content | `bg-background` | `bg-background` | Breathable, open. Card-based layout for temple results. |
| Cards | `bg-card shadow-warm-md` | `bg-card shadow-warm-md` | Temple detail cards with `border-l-4 border-primary` accent line. Padding 1.5rem. |
| Footer | `bg-muted/40 border-t-2 border-primary` | `bg-muted/40 border-t-2 border-primary` | Warm accent top border. Links in muted-foreground. |
| Button (Primary) | `bg-primary text-primary-foreground btn-accessible` | `bg-primary text-primary-foreground btn-accessible` | Min height 48px. Warm ochre. State: hover `opacity-90`, active `ring-2 ring-primary`. |

## Spacing & Rhythm
- **Gap**: 1rem (16px) for component spacing, 2rem (32px) for section spacing
- **Padding**: Cards 1.5rem, containers 2rem, mobile 1rem
- **List items**: 0.875rem vertical margin for breathing room
- **Density**: Generous whitespace supports age-diverse accessibility

## Component Patterns
- **Search bar**: Large, 48px height, clear placeholder text, icon + input in one container
- **Temple cards**: Grid-based (sm:1 md:2 lg:3). Image placeholder, title (body-lg), location (muted-foreground), action buttons below
- **Timings/Schedules**: Table with generous cell padding, accent color for "Open" status
- **Location map**: Embedded map placeholder, "Get Directions" button primary color
- **Forms**: Large labels (text-base), 48px inputs, focus-ring utility for accessibility

## Motion
- **Transition**: Smooth 0.3s cubic-bezier for all interactive elements (buttons, hover states)
- **Loading**: Gentle fade-in for cards (200ms)
- **No**: Bounces, spring physics, or rapid animations — keep spiritual reverence

## Accessibility Constraints
- **Minimum text size**: 1rem for body, 1.5rem for headings
- **Button minimum**: 48x48px touch target (btn-accessible utility)
- **Contrast**: All text meets WCAG AA (lightness difference ≥ 0.7)
- **Focus states**: Visible 2px ring with offset
- **Form labels**: Always visible, never placeholder-only

## Signature Detail
Warm ochre/terracotta accent border on left edge of temple detail cards — echoes temple architecture, creates visual rhythm without ornamentation.
