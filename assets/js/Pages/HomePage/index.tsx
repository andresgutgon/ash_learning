import { useHost } from '@/hooks/useHost'
import { login } from '@/actions/Auth/SessionsController'

function HomePage() {
  const { buildAppUrl } = useHost()
  const loginUrl = buildAppUrl({ path: login.url().path })
  return (
    <div className='h-screen flex flex-col items-center justify-center gap-y-4'>
      <div className='flex flex-col items-center'>
        Welcome to the Home Page
        Ugly as fuck page
      </div>
      <a href={loginUrl}>
        Login
      </a>
    </div>
  )
}

export default HomePage
