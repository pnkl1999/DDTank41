namespace Game.Logic.Phy.Object
{
    public class LayerTop : PhysicalObj
    {
        public override int Type=> 0;

        public LayerTop(int id, string name, string model, string defaultAction, int scale, int rotation)
			: base(id, name, model, defaultAction, scale, rotation, -1)
        {
        }
    }
}
