package com.pickgliss.ui.controls
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.cell.IListCellFactory;
   import com.pickgliss.ui.controls.list.IListModel;
   import com.pickgliss.ui.controls.list.List;
   import com.pickgliss.ui.controls.list.VectorListModel;
   import com.pickgliss.utils.ClassUtils;
   
   public class ListPanel extends ScrollPanel
   {
      
      public static const P_backgound:String = "backgound";
      
      public static const P_backgoundInnerRect:String = "backgoundInnerRect";
      
      public static const P_factory:String = "factory";
       
      
      protected var _factory:IListCellFactory;
      
      protected var _factoryStrle:String;
      
      protected var _listStyle:String;
      
      public function ListPanel()
      {
         super(false);
      }
      
      override public function dispose() : void
      {
         this._factory = null;
         super.dispose();
      }
      
      public function set factoryStyle(param1:String) : void
      {
         if(this._factoryStrle == param1)
         {
            return;
         }
         this._factoryStrle = param1;
         var _loc2_:Array = param1.split("|");
         var _loc3_:String = _loc2_[0];
         var _loc4_:Array = ComponentFactory.parasArgs(_loc2_[1]);
         this._factory = ClassUtils.CreatInstance(_loc3_,_loc4_);
         onPropertiesChanged(P_factory);
      }
      
      public function get list() : List
      {
         return _viewSource as List;
      }
      
      public function get listModel() : IListModel
      {
         return this.list.model;
      }
      
      public function set listStyle(param1:String) : void
      {
         if(this._listStyle == param1)
         {
            return;
         }
         this._listStyle = param1;
         viewPort = ComponentFactory.Instance.creat(this._listStyle);
      }
      
      public function get vectorListModel() : VectorListModel
      {
         return this.list.model as VectorListModel;
      }
      
      override protected function onProppertiesUpdate() : void
      {
         super.onProppertiesUpdate();
         if(_changedPropeties[P_factory] || _changedPropeties[ScrollPanel.P_viewSource])
         {
            if(this.list)
            {
               this.list.cellFactory = this._factory;
            }
         }
      }
   }
}
