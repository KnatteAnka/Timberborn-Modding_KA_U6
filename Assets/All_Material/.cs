using System.Threading.Tasks;
using ThunderKit.Core.Pipelines;

namespace All_Material
{
    [PipelineSupport(typeof(Pipeline))]
    public class  : PipelineJob
    {
        public override Task Execute(Pipeline pipeline)
        {
            return Task.CompletedTask;
        }
    }
}
