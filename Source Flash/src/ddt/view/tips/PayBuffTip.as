package ddt.view.tips
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.container.VBox;
   import ddt.data.BuffInfo;
   import flash.events.Event;
   
   public class PayBuffTip extends BuffTip
   {
       
      
      private var _buffContainer:VBox;
      
      private var _describe:String;
      
      public function PayBuffTip()
      {
         super();
         this._buffContainer = ComponentFactory.Instance.creatComponentByStylename("asset.core.PayBuffTipContainer");
         addChild(this._buffContainer);
         _activeSp.visible = false;
         addEventListener(Event.REMOVED_FROM_STAGE,this.__leaveStage);
      }
      
      private function __leaveStage(param1:Event) : void
      {
         this._buffContainer.disposeAllChildren();
      }
      
      override protected function drawNameField() : void
      {
         name_txt = ComponentFactory.Instance.creat("core.PayBuffTipNameTxt");
         addChild(name_txt);
      }
      
      override protected function setShow(param1:Boolean, param2:Boolean, param3:int, param4:int, param5:int, param6:String) : void
      {
         var _loc7_:BuffInfo = null;
         _active = param1;
         this._describe = param6;
         this._buffContainer.disposeAllChildren();
         if(_active)
         {
            for each(_loc7_ in _tempData.linkBuffs)
            {
               if(_loc7_.valided)
               {
                  this._buffContainer.addChild(new PayBuffListItem(_loc7_));
               }
            }
         }
         this.updateTxt();
         this.updateWH();
      }
      
      private function updateTxt() : void
      {
         if(_active)
         {
            name_txt.text = _tempData.name;
            setChildIndex(name_txt,numChildren - 1);
            describe_txt.visible = false;
            name_txt.visible = true;
         }
         else
         {
            describe_txt.text = this._describe;
            describe_txt.visible = true;
            name_txt.visible = false;
         }
      }
      
      override protected function updateWH() : void
      {
         if(_active)
         {
            _bg.width = this._buffContainer.x + this._buffContainer.width + this._buffContainer.x;
            _bg.height = this._buffContainer.y + this._buffContainer.height + 16;
         }
         else
         {
            _bg.width = int(describe_txt.x + describe_txt.width);
            _bg.height = int(describe_txt.y + describe_txt.height + 10);
         }
         _width = _bg.width;
         _height = _bg.height;
         name_txt.x = _width - name_txt.width >> 1;
      }
   }
}
