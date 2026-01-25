import { Link } from "@inertiajs/react";
import type { OAuthProvider, UserIdentity } from "@/types";

type Props = {
  providers: OAuthProvider[];
  identities: UserIdentity[];
};

// Group identities by strategy/provider
function groupIdentitiesByProvider(identities: UserIdentity[]) {
  return identities.reduce(
    (acc, identity) => {
      const strategy = identity.strategy;
      if (!acc[strategy]) {
        acc[strategy] = [];
      }
      acc[strategy].push(identity);
      return acc;
    },
    {} as Record<string, UserIdentity[]>
  );
}

function ProviderIcon({ name, className = "w-6 h-6" }: { name: string; className?: string }) {
  if (name === "github") {
    return (
      <svg viewBox="0 0 24 24" fill="currentColor" className={`${className} text-gray-700`}>
        <path d="M12 0C5.37 0 0 5.506 0 12.303c0 5.445 3.435 10.043 8.205 11.674.6.107.825-.262.825-.585 0-.292-.015-1.261-.015-2.291C6 21.67 5.22 20.346 4.98 19.654c-.135-.354-.72-1.446-1.23-1.738-.42-.23-1.02-.8-.015-.815.945-.015 1.62.892 1.845 1.261 1.08 1.86 2.805 1.338 3.495 1.015.105-.8.42-1.338.765-1.645-2.67-.308-5.46-1.37-5.46-6.075 0-1.338.465-2.446 1.23-3.307-.12-.308-.54-1.569.12-3.26 0 0 1.005-.323 3.3 1.26.96-.276 1.98-.415 3-.415s2.04.139 3 .416c2.295-1.6 3.3-1.261 3.3-1.261.66 1.691.24 2.952.12 3.26.765.861 1.23 1.953 1.23 3.307 0 4.721-2.805 5.767-5.475 6.075.435.384.81 1.122.81 2.276 0 1.645-.015 2.968-.015 3.383 0 .323.225.707.825.585a12.047 12.047 0 0 0 5.919-4.489A12.536 12.536 0 0 0 24 12.304C24 5.505 18.63 0 12 0Z" />
      </svg>
    );
  }

  if (name === "google") {
    return (
      <svg viewBox="0 0 24 24" className={className}>
        <path
          d="M22.56 12.25c0-.78-.07-1.53-.2-2.25H12v4.26h5.92c-.26 1.37-1.04 2.53-2.21 3.31v2.77h3.57c2.08-1.92 3.28-4.74 3.28-8.09z"
          fill="#4285F4"
        />
        <path
          d="M12 23c2.97 0 5.46-.98 7.28-2.66l-3.57-2.77c-.98.66-2.23 1.06-3.71 1.06-2.86 0-5.29-1.93-6.16-4.53H2.18v2.84C3.99 20.53 7.7 23 12 23z"
          fill="#34A853"
        />
        <path
          d="M5.84 14.09c-.22-.66-.35-1.36-.35-2.09s.13-1.43.35-2.09V7.07H2.18C1.43 8.55 1 10.22 1 12s.43 3.45 1.18 4.93l2.85-2.22.81-.62z"
          fill="#FBBC05"
        />
        <path
          d="M12 5.38c1.62 0 3.06.56 4.21 1.64l3.15-3.15C17.45 2.09 14.97 1 12 1 7.7 1 3.99 3.47 2.18 7.07l3.66 2.84c.87-2.6 3.3-4.53 6.16-4.53z"
          fill="#EA4335"
        />
      </svg>
    );
  }

  // Default globe icon
  return (
    <svg
      viewBox="0 0 24 24"
      fill="none"
      stroke="currentColor"
      strokeWidth={2}
      className={`${className} text-gray-500`}
    >
      <circle cx="12" cy="12" r="10" />
      <path d="M2 12h20M12 2a15.3 15.3 0 0 1 4 10 15.3 15.3 0 0 1-4 10 15.3 15.3 0 0 1-4-10 15.3 15.3 0 0 1 4-10z" />
    </svg>
  );
}

function IdentityRow({
  identity,
  provider,
}: {
  identity: UserIdentity;
  provider: OAuthProvider;
}) {
  const disconnectUrl = `/providers/${provider.name}/${encodeURIComponent(identity.uid)}`;

  return (
    <div className="flex items-center justify-between p-3 pl-12">
      <div className="flex items-center gap-2">
        {identity.avatar_url && (
          <img
            src={identity.avatar_url}
            alt={`${provider.display_name} profile`}
            referrerPolicy="no-referrer"
            className="w-8 h-8 rounded-full"
          />
        )}
        <div>
          {identity.full_name && (
            <span className="text-sm font-medium">{identity.full_name}</span>
          )}
          {identity.email && (
            <p className="text-xs text-gray-500">{identity.email}</p>
          )}
        </div>
      </div>

      <Link
        href={disconnectUrl}
        method="delete"
        as="button"
        className="px-2 py-1 text-xs font-medium text-red-600 border border-red-300 rounded hover:bg-red-50 transition-colors"
        onBefore={() =>
          confirm(
            `Are you sure you want to disconnect this ${provider.display_name} account?`
          )
        }
      >
        Disconnect
      </Link>
    </div>
  );
}

function ProviderSection({
  provider,
  identities,
}: {
  provider: OAuthProvider;
  identities: UserIdentity[];
}) {
  const isConnected = identities.length > 0;

  return (
    <div className="border border-gray-200 rounded-lg bg-white overflow-hidden">
      {/* Provider header with connect button */}
      <div className="flex items-center justify-between p-4 bg-gray-50">
        <div className="flex items-center gap-3">
          <ProviderIcon name={provider.icon} />
          <div>
            <h3 className="font-medium">{provider.display_name}</h3>
            {isConnected ? (
              <p className="text-sm text-green-600 flex items-center gap-1">
                <svg className="w-4 h-4" viewBox="0 0 20 20" fill="currentColor">
                  <path
                    fillRule="evenodd"
                    d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z"
                    clipRule="evenodd"
                  />
                </svg>
                {identities.length} account(s) connected
              </p>
            ) : (
              <p className="text-sm text-gray-500">Not connected</p>
            )}
          </div>
        </div>

        <a
          href={provider.auth_url}
          className="inline-flex items-center gap-1.5 px-3 py-1.5 text-sm font-medium text-white bg-indigo-600 rounded-md hover:bg-indigo-700 transition-colors"
        >
          <svg className="w-4 h-4" viewBox="0 0 20 20" fill="currentColor">
            <path
              fillRule="evenodd"
              d="M12.586 4.586a2 2 0 112.828 2.828l-3 3a2 2 0 01-2.828 0 1 1 0 00-1.414 1.414 4 4 0 005.656 0l3-3a4 4 0 00-5.656-5.656l-1.5 1.5a1 1 0 101.414 1.414l1.5-1.5zm-5 5a2 2 0 012.828 0 1 1 0 101.414-1.414 4 4 0 00-5.656 0l-3 3a4 4 0 105.656 5.656l1.5-1.5a1 1 0 10-1.414-1.414l-1.5 1.5a2 2 0 11-2.828-2.828l3-3z"
              clipRule="evenodd"
            />
          </svg>
          {isConnected ? "Add another" : "Connect"}
        </a>
      </div>

      {/* Connected identities list */}
      {isConnected && (
        <div className="divide-y divide-gray-200">
          {identities.map((identity) => (
            <IdentityRow
              key={identity.id}
              identity={identity}
              provider={provider}
            />
          ))}
        </div>
      )}
    </div>
  );
}

export function ProvidersList({ providers, identities }: Props) {
  const identitiesByProvider = groupIdentitiesByProvider(identities);

  return (
    <div className="space-y-4">
      <div>
        <h2 className="text-lg font-semibold">Connect your accounts</h2>
        <p className="text-gray-600">
          Link your social accounts to enable sign-in with multiple providers.
        </p>
      </div>

      <div className="space-y-3">
        {providers.map((provider) => (
          <ProviderSection
            key={provider.name}
            provider={provider}
            identities={identitiesByProvider[provider.name] || []}
          />
        ))}
      </div>
    </div>
  );
}

export default ProvidersList;
