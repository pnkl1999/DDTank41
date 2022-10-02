<?php

namespace Models;

use Illuminate\Database\Eloquent\Model;

class ConfigCharge extends Model
{
    protected $table='Config_Charge';
    
    protected $primaryKey='id';
    
    public $timestamps = false;
    
    protected $guarded = ['id'];
}