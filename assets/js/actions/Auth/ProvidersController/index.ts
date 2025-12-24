import { buildUrl, type RouteQueryOptions, type RouteDefinition, type RouteDefinitionWithParameters, type WayfinderUrl } from './../../../wayfinder'

/**
 * @see AshLearningWeb.Auth.ProvidersController::delete
 * @see lib/ash_learning_web/controllers/auth/providers_controller.ex:4
 * @route /providers/:provider/:uid
*/

export const deleteMethod = (args: { provider: string | number, uid: string | number } | [string | number, string | number], options?: RouteQueryOptions): RouteDefinition<'delete'> => ({
  url: deleteMethod.url(args, options).path,
  method: 'delete',
})

deleteMethod.definition = {
  methods: ["delete"],
  url: '/providers/:provider/:uid',
  parameters: { provider: { name: "provider", optional: false, required: true, glob: false }, uid: { name: "uid", optional: false, required: true, glob: false } }
} satisfies RouteDefinitionWithParameters<['delete']>

deleteMethod.url = (args: { provider: string | number, uid: string | number } | [string | number, string | number],  options?: RouteQueryOptions): WayfinderUrl => {
  return buildUrl({
    definition: deleteMethod.definition,
    args,
    options
  })
}

deleteMethod.delete = (args: { provider: string | number, uid: string | number } | [string | number, string | number], options?: RouteQueryOptions): RouteDefinition<'delete'> => ({
  url: deleteMethod.url(args, options).path,
  method: 'delete',
})


const ProvidersController = { delete: deleteMethod }

export default ProvidersController
