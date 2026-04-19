import { buildUrl, type RouteQueryOptions, type RouteDefinition, type RouteDefinitionWithParameters, type WayfinderUrl } from './../../../wayfinder'

/**
 * @see AshLearningWeb.Auth.OAuthRedirectController::redirect_with_return_to
 * @see lib/ash_learning_web/controllers/auth/oauth_redirect_controller.ex:5
 * @route /oauth/:provider
*/

export const redirectWithReturnTo = (args: { provider: string | number } | [string | number] | string | number, options?: RouteQueryOptions): RouteDefinition<'get'> => ({
  url: redirectWithReturnTo.url(args, options).path,
  method: 'get',
})

redirectWithReturnTo.definition = {
  methods: ["get"],
  url: '/oauth/:provider',
  parameters: { provider: { name: "provider", optional: false, required: true, glob: false } }
} satisfies RouteDefinitionWithParameters<['get']>

redirectWithReturnTo.url = (args: { provider: string | number } | [string | number] | string | number,  options?: RouteQueryOptions): WayfinderUrl => {
  return buildUrl({
    definition: redirectWithReturnTo.definition,
    args,
    options
  })
}

redirectWithReturnTo.get = (args: { provider: string | number } | [string | number] | string | number, options?: RouteQueryOptions): RouteDefinition<'get'> => ({
  url: redirectWithReturnTo.url(args, options).path,
  method: 'get',
})


const OAuthRedirectController = { redirectWithReturnTo }

export default OAuthRedirectController
