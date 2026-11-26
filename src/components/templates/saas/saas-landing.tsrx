import CTA from "./cta.tsrx"
import FAQ from "./faq.tsrx"
import Features from "./features.tsrx"
import Footer from "./footer.tsrx"
import Hero from "./hero.tsrx"
import HowItWorks from "./how-it-works.tsrx"
import Logos from "./logos.tsrx"
import Navbar from "./navbar.tsrx"
import Pricing from "./pricing.tsrx"
import ProductTabs from "./product-tabs.tsrx"
import Stats from "./stats.tsrx"
import Testimonials from "./testimonials.tsrx"

// Upstream's page metadata, for the route's head().
export const metadata = {
  title: "Planly - Plan less. Ship more.",
  description:
    "The fast, focused project tracker for teams that ship. Issues, roadmaps and AI triage in one workspace.",
}

export default function SaasLanding() @{
  <div class="min-h-screen bg-background font-base text-foreground">
    <Navbar />
    <main>
      <Hero />
      <Logos />
      <Features />
      <ProductTabs />
      <HowItWorks />
      <Stats />
      <Pricing />
      <Testimonials />
      <FAQ />
      <CTA />
    </main>
    <Footer />
  </div>
}
