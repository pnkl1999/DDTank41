package game.model
{
   public class PlayerAdditionInfo
   {
       
      
      private var _auncherExperienceAddition:Number = 1;
      
      private var _gmExperienceAdditionType:Number = 1;
      
      private var _gmOfferAddition:Number = 1;
      
      private var _auncherOfferAddition:Number = 1;
      
      private var _gmRichesAddition:Number = 1;
      
      private var _auncherRichesAddition:Number = 1;
      
      public function PlayerAdditionInfo()
      {
         super();
      }
      
      public function get AuncherExperienceAddition() : Number
      {
         return this._auncherExperienceAddition;
      }
      
      public function set AuncherExperienceAddition(param1:Number) : void
      {
         this._auncherExperienceAddition = param1;
      }
      
      public function get GMExperienceAdditionType() : Number
      {
         return this._gmExperienceAdditionType;
      }
      
      public function set GMExperienceAdditionType(param1:Number) : void
      {
         this._gmExperienceAdditionType = param1;
      }
      
      public function get GMOfferAddition() : Number
      {
         return this._gmOfferAddition;
      }
      
      public function set GMOfferAddition(param1:Number) : void
      {
         this._gmOfferAddition = param1;
      }
      
      public function get AuncherOfferAddition() : Number
      {
         return this._auncherOfferAddition;
      }
      
      public function set AuncherOfferAddition(param1:Number) : void
      {
         this._auncherOfferAddition = param1;
      }
      
      public function get GMRichesAddition() : Number
      {
         return this._gmRichesAddition;
      }
      
      public function set GMRichesAddition(param1:Number) : void
      {
         this._gmRichesAddition = param1;
      }
      
      public function get AuncherRichesAddition() : Number
      {
         return this._auncherRichesAddition;
      }
      
      public function set AuncherRichesAddition(param1:Number) : void
      {
         this._auncherRichesAddition = param1;
      }
      
      public function resetAddition() : void
      {
         this._auncherExperienceAddition = 1;
         this._gmExperienceAdditionType = 1;
         this._gmOfferAddition = 1;
         this._auncherOfferAddition = 1;
         this._gmRichesAddition = 1;
         this._auncherRichesAddition = 1;
      }
   }
}
