import {
  RouterProvider,
  createRootRoute,
  createRoute,
  createRouter,
} from "@tanstack/react-router";
import Layout from "./components/Layout";
import AdminDashboardPage from "./pages/AdminDashboardPage";
import HomePage from "./pages/HomePage";
import LoginPage from "./pages/LoginPage";
import RegisterPage from "./pages/RegisterPage";
import TempleDetailPage from "./pages/TempleDetailPage";
import TemplesSearchPage from "./pages/TemplesSearchPage";
import UserDashboardPage from "./pages/UserDashboardPage";

// Routes
const rootRoute = createRootRoute({ component: Layout });

const indexRoute = createRoute({
  getParentRoute: () => rootRoute,
  path: "/",
  component: HomePage,
});

const loginRoute = createRoute({
  getParentRoute: () => rootRoute,
  path: "/login",
  component: LoginPage,
});

const registerRoute = createRoute({
  getParentRoute: () => rootRoute,
  path: "/register",
  component: RegisterPage,
});

const templesRoute = createRoute({
  getParentRoute: () => rootRoute,
  path: "/temples",
  component: TemplesSearchPage,
  validateSearch: (search: Record<string, unknown>) => ({
    q: (search.q as string) ?? "",
    nearby: (search.nearby as string) ?? "",
    state: (search.state as string) ?? "",
    category: (search.category as string) ?? "",
  }),
});

const templeDetailRoute = createRoute({
  getParentRoute: () => rootRoute,
  path: "/temples/$id",
  component: TempleDetailPage,
});

const userDashboardRoute = createRoute({
  getParentRoute: () => rootRoute,
  path: "/dashboard/user",
  component: UserDashboardPage,
});

const adminDashboardRoute = createRoute({
  getParentRoute: () => rootRoute,
  path: "/dashboard/admin",
  component: AdminDashboardPage,
});

const routeTree = rootRoute.addChildren([
  indexRoute,
  loginRoute,
  registerRoute,
  templesRoute,
  templeDetailRoute,
  userDashboardRoute,
  adminDashboardRoute,
]);

const router = createRouter({ routeTree });

declare module "@tanstack/react-router" {
  interface Register {
    router: typeof router;
  }
}

export default function App() {
  return <RouterProvider router={router} />;
}
