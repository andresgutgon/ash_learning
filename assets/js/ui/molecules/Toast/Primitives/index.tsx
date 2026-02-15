import { cva, type VariantProps } from 'class-variance-authority'
import {
  CircleCheckIcon,
  InfoIcon,
  TriangleAlertIcon,
  OctagonXIcon,
  Loader2Icon,
  LucideProps,
} from 'lucide-react'
import { useTheme } from 'next-themes'
import { ForwardRefExoticComponent, RefAttributes } from 'react'
import { Toaster as Sonner, toast as sonnerToast, ToasterProps } from 'sonner'

import { cn } from '@/lib/utils'
import { ButtonProps, Button } from '@/ui/atoms/Button'
import { Text } from '@/ui/atoms/Text'
import { BackgroundColor, colors, TextColor } from '@/ui/tokens/colors'
type IconComponent = ForwardRefExoticComponent<
  Omit<LucideProps, 'ref'> & RefAttributes<SVGSVGElement>
>
const toastVariants = cva('', {
  variants: {
    variant: {
      default: 'bg-background ring-input', // TODO: Check
      warning: 'bg-warning ring-warning-border',
      success: 'bg-success ring-success-border',
      destructive: 'bg-destructive ring-destructive-border',
    },
  },
  defaultVariants: {
    variant: 'default',
  },
})

function iconBgColor(variant: ToastProps['variant']): BackgroundColor {
  switch (variant) {
    case 'success':
      return 'successMuted'
    case 'destructive':
      return 'destructiveMuted'
    case 'warning':
      return 'warningMuted'
    default:
      return 'sidebar'
  }
}

function iconColor(variant: ToastProps['variant']): TextColor {
  switch (variant) {
    case 'success':
      return 'success'
    case 'destructive':
      return 'destructive'
    case 'warning':
      return 'warning'
    default:
      return 'foreground'
  }
}

function getIconComponent(variant: Variant | 'loading'): IconComponent {
  switch (variant) {
    case 'success':
      return CircleCheckIcon
    case 'destructive':
      return OctagonXIcon
    case 'warning':
      return TriangleAlertIcon
    case 'loading':
      return Loader2Icon
    default:
      return InfoIcon
  }
}

function getButtonVariant(variant: Variant): ButtonProps['variant'] {
  switch (variant) {
    case 'success':
      return 'success'
    case 'destructive':
      return 'destructive'
    case 'warning':
      return 'warning'
    default:
      return 'secondary'
  }
}

function titleColor(variant: ToastProps['variant']): TextColor {
  if (!variant || variant === 'default') {
    return 'foreground'
  }
  return variant
}

function descriptionColor(variant: ToastProps['variant']): TextColor {
  switch (variant) {
    case 'success':
      return 'successMuted'
    case 'destructive':
      return 'destructiveMuted'
    case 'warning':
      return 'warningMuted'
    default:
      return 'mutedForeground'
  }
}

type Variant = VariantProps<typeof toastVariants>['variant']
export type ToastProps = {
  id: string | number
  title: string
  variant?: Variant
  description?: string
  width?: 'normal' | 'full'
  loading?: boolean
  shadow?: boolean
  button?: {
    label: string
    onClick: () => void
  }
}

export function Toast({
  id,
  variant = 'default',
  width = 'full',
  shadow,
  title,
  description,
  button,
  loading = false,
}: ToastProps) {
  const IconComponent = getIconComponent(loading ? 'loading' : variant)
  return (
    <div
      className={cn('flex w-full gap-x-3 rounded-md p-4 ring-1', toastVariants({ variant }), {
        'md:w-80': width === 'normal',
        'shadow-md': shadow,
      })}
    >
      {IconComponent ? (
        <div
          className={cn(
            'h-8 w-8 shrink-0 rounded-md',
            'mr-3 flex items-center justify-center',
            colors.backgrounds[iconBgColor(variant)],
          )}
        >
          <IconComponent className={cn(colors.textColors[iconColor(variant)])} />
        </div>
      ) : null}

      <div className='mr-3 min-w-0 flex-1'>
        <Text.H5M display='block' asChild color={titleColor(variant)}>
          <h3>{title}</h3>
        </Text.H5M>
        {description && (
          <Text.H5 display='block' asChild color={descriptionColor(variant)}>
            <p>{description}</p>
          </Text.H5>
        )}
      </div>
      {button ? (
        <div className='shrink-0'>
          <Button
            size='sm'
            variant={getButtonVariant(variant)}
            onClick={() => {
              button.onClick()
              sonnerToast.dismiss(id)
            }}
          >
            {button.label}
          </Button>
        </div>
      ) : null}
    </div>
  )
}
const Toaster = ({ ...props }: ToasterProps) => {
  const { theme = 'system' } = useTheme()

  return (
    <Sonner
      theme={theme as ToasterProps['theme']}
      className='toaster group'
      icons={{
        success: <CircleCheckIcon className='size-4' />,
        info: <InfoIcon className='size-4' />,
        warning: <TriangleAlertIcon className='size-4' />,
        error: <OctagonXIcon className='size-4' />,
        loading: <Loader2Icon className='size-4 animate-spin' />,
      }}
      style={
        {
          '--normal-bg': 'var(--popover)',
          '--normal-text': 'var(--popover-foreground)',
          '--normal-border': 'var(--border)',
          '--border-radius': 'var(--radius)',
        } as React.CSSProperties
      }
      toastOptions={{
        classNames: {
          toast: 'cn-toast',
        },
      }}
      {...props}
    />
  )
}

export { Toaster }
