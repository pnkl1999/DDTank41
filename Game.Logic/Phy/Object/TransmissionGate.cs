namespace Game.Logic.Phy.Object
{
    public class TransmissionGate : PhysicalObj
    {
        public override int Type=> 3;

        public TransmissionGate(int id, string name, string model, string defaultAction, int scale, int rotation)
			: base(id, name, model, defaultAction, scale, rotation, 0)
        {
        }
    }
}
