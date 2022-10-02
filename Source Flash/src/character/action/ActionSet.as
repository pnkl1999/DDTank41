package character.action
{
   import flash.events.EventDispatcher;
   
   public class ActionSet extends EventDispatcher
   {
       
      
      private var _actions:Array;
      
      private var _currentAction:BaseAction;
      
      public function ActionSet(actionDefine:XML = null)
      {
         super();
         this._actions = [];
         if(actionDefine)
         {
            this.parseFromXml(actionDefine);
         }
      }
      
      public function addAction(action:BaseAction) : void
      {
         if(action)
         {
            this._actions.push(action);
         }
      }
      
      public function getAction(name:String) : BaseAction
      {
         var action:BaseAction = null;
         for each(action in this._actions)
         {
            if(action.name == name)
            {
               return action;
            }
         }
         return null;
      }
      
      public function get next() : BaseAction
      {
         var action:BaseAction = null;
         for each(action in this._actions)
         {
            if(action.name == this._currentAction.name)
            {
               return action;
            }
         }
         return this._currentAction;
      }
      
      public function get currentAction() : BaseAction
      {
         if(this._currentAction)
         {
            return this._currentAction;
         }
         if(this._actions.length > 0)
         {
            this._currentAction = this._actions[0];
         }
         return this._currentAction;
      }
      
      public function get stringActions() : Array
      {
         var action:BaseAction = null;
         var result:Array = [];
         for each(action in this._actions)
         {
            result.push(action.name);
         }
         return result;
      }
      
      public function get actions() : Array
      {
         return this._actions;
      }
      
      public function removeAction(action:String) : void
      {
         var act:BaseAction = null;
         for each(act in this._actions)
         {
            if(act.name == action)
            {
               this._actions.splice(this._actions.indexOf(act),1);
               act.dispose();
            }
         }
      }
      
      private function parseFromXml(xml:XML) : void
      {
      }
      
      public function toXml() : XML
      {
         var action:BaseAction = null;
         var result:XML = <actionSet></actionSet>;
         for(var i:int = 0; i < this._actions.length; i++)
         {
            action = this._actions[i];
            result.appendChild(action.toXml());
         }
         return result;
      }
      
      public function dispose() : void
      {
         var action:BaseAction = null;
         for each(action in this._actions)
         {
            action.dispose();
         }
      }
   }
}
