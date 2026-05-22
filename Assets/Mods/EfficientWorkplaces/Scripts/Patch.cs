using HarmonyLib;
using Timberborn.PlantingUI;
using Timberborn.Planting;
using Timberborn.TemplateSystem;
using Timberborn.EntitySystem;
using Timberborn.Localization;
using System.Linq;

namespace EfficientFarmhouse.PlantingFix
{
    [HarmonyPatch(typeof(PlantingToolButtonFactory), "GetPlanterBuildingName")]
    public class PatchPlantingToolButtonFactory
    {
        private static bool Prefix(PlantableSpec plantableSpec,
                                   TemplateService ____templateService,
                                   ILoc ____loc,
                                   ref string __result)
        {
            //Debug.Log("Efficient Workplaces: Patch run Farmhouse");
            // Find the first building that matches the resource group instead of crashing on multiples
            var buildingSpec = ____templateService.GetAll<PlanterBuildingSpec>()
                .FirstOrDefault(building => building.PlantableResourceGroup == plantableSpec.ResourceGroup);

            if (buildingSpec != null)
            {
                string displayNameLocKey = buildingSpec.GetSpec<LabeledEntitySpec>().DisplayNameLocKey;
                __result = ____loc.T(displayNameLocKey);
            }
            else
            {
                // Fallback if no building is found at all
                __result = "Unknown Planter";
            }

            return false; // Skip the original method to prevent the crash
        }
    }
}