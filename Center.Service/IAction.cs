using System.Collections;

namespace Game.Service
{
    internal interface IAction
    {
        string Name { get; }

        string Syntax { get; }

        string Description { get; }

        void OnAction(Hashtable parameters);
    }
}
