import { useEffect, useState } from "react";
import type { UserProfile } from "../types";
import { useAuth } from "./useAuth";

const STORAGE_KEY = "ftob_user_profile";

export function useUserProfile() {
  const { isAuthenticated, principal } = useAuth();
  const [profile, setProfile] = useState<UserProfile | null>(null);
  const [isLoading, setIsLoading] = useState(false);

  useEffect(() => {
    if (!isAuthenticated || !principal) {
      setProfile(null);
      return;
    }
    setIsLoading(true);
    try {
      const stored = localStorage.getItem(
        `${STORAGE_KEY}_${principal.toString()}`,
      );
      if (stored) {
        setProfile(JSON.parse(stored) as UserProfile);
      }
    } catch {
      setProfile(null);
    } finally {
      setIsLoading(false);
    }
  }, [isAuthenticated, principal]);

  const saveProfile = (data: Partial<UserProfile>) => {
    if (!principal) return;
    const updated: UserProfile = {
      name: data.name ?? profile?.name ?? "",
      email: data.email ?? profile?.email,
      role: data.role ?? profile?.role ?? "user",
      bookmarks: data.bookmarks ?? profile?.bookmarks ?? [],
      createdAt: profile?.createdAt ?? new Date().toISOString(),
    };
    localStorage.setItem(
      `${STORAGE_KEY}_${principal.toString()}`,
      JSON.stringify(updated),
    );
    setProfile(updated);
  };

  const clearProfile = () => {
    if (!principal) return;
    localStorage.removeItem(`${STORAGE_KEY}_${principal.toString()}`);
    setProfile(null);
  };

  return {
    profile,
    isLoading,
    saveProfile,
    clearProfile,
    isAdmin: profile?.role === "admin",
  };
}
