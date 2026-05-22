using Bindito.Core;
using HarmonyLib;
using Timberborn.TemplateSystem;
using UnityEngine;

namespace EfficientFarmhouse.PlantingFix
{
    // This attribute tells the game to run this code when the Game scene loads
    [Context("Game")]
    public class PlantingPatchConfigurator : IConfigurator
    {
        private static readonly string PatchId = "com.yourname.plantingfix";

        public void Configure(IContainerDefinition containerDefinition)
        {
            
            var harmony = new Harmony(PatchId);
            harmony.PatchAll(); // This automatically finds and applies your [HarmonyPatch] class
            Debug.Log("Efficient Workplaces: Farmhouse Patched!");
        }
    }
}