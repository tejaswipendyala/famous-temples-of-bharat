import { Toaster } from "@/components/ui/sonner";
import { Outlet } from "@tanstack/react-router";
import { ThemeProvider, useTheme } from "next-themes";
import Footer from "./Footer";
import Header from "./Header";

function LayoutInner() {
  const { setTheme, resolvedTheme } = useTheme();
  const isDark = resolvedTheme === "dark";

  const toggleTheme = () => setTheme(isDark ? "light" : "dark");

  return (
    <div className="min-h-screen flex flex-col bg-background text-foreground">
      <Header isDark={isDark} onToggleTheme={toggleTheme} />
      <main className="flex-1 bg-background">
        <Outlet />
      </main>
      <Footer />
      <Toaster richColors position="top-right" />
    </div>
  );
}

export default function Layout() {
  return (
    <ThemeProvider attribute="class" defaultTheme="light" enableSystem={false}>
      <LayoutInner />
    </ThemeProvider>
  );
}
