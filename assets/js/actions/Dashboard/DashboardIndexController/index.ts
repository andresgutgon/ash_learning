import { buildUrl, type RouteQueryOptions, type RouteDefinition, type RouteDefinitionWithParameters, type WayfinderUrl } from './../../../wayfinder'

/**
 * @see AshLearningWeb.Dashboard.DashboardIndexController::index
 * @see lib/ash_learning_web/controllers/dashboard/dashboard_controller.ex:6
 * @route /dashboard
*/

export const dashboard = (options?: RouteQueryOptions): RouteDefinition<'get'> => ({
  url: dashboard.url(options).path,
  method: 'get',
})

dashboard.definition = {
  methods: ["get"],
  url: '/dashboard',
  parameters: {}
} satisfies RouteDefinitionWithParameters<['get']>

dashboard.url = (options?: RouteQueryOptions): WayfinderUrl => {
  return buildUrl({
    definition: dashboard.definition,
    options
  })
}

dashboard.get = (options?: RouteQueryOptions): RouteDefinition<'get'> => ({
  url: dashboard.url(options).path,
  method: 'get',
})


const DashboardIndexController = { dashboard }

export default DashboardIndexController
