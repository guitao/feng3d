package me.feng3d.fagal.vertex
{
	import me.feng3d.core.register.Register;
	import me.feng3d.fagal.base.getFreeTemp;
	import me.feng3d.fagal.base.removeTemp;
	import me.feng3d.fagal.base.operation.crs;
	import me.feng3d.fagal.base.operation.m33;
	import me.feng3d.fagal.base.operation.mov;
	import me.feng3d.fagal.base.operation.nrm;

	/**
	 * 编译切线顶点程序
	 * @param normalInput				法线数据
	 * @param tangentInput				切线数据
	 * @param matrix					法线场景变换矩阵(模型空间转场景空间)
	 * @param normalVarying				法线变量寄存器
	 * @param tangentVarying			切线变量寄存器
	 * @param bitangentVarying			双切线变量寄存器
	 * @author warden_feng 2014-11-7
	 */
	public function V_TangentNormalMap(normalInput:Register, tangentInput:Register, matrix:Register, normalVarying:Register, tangentVarying:Register, bitangentVarying:Register):void
	{
		var animatedNormal:Register = getFreeTemp("动画后顶点法线临时寄存器");
		var animatedTangent:Register = getFreeTemp("动画后顶点切线临时寄存器");
		var bitanTemp:Register = getFreeTemp("动画后顶点双切线临时寄存器");

		//赋值法线数据
		mov(animatedNormal, normalInput);
		//赋值切线数据
		mov(animatedTangent, tangentInput);

		//计算顶点世界法线 vc8：模型转世界矩阵
		m33(animatedNormal.xyz, animatedNormal, matrix);
		//标准化顶点世界法线
		nrm(animatedNormal.xyz, animatedNormal);

		//计算顶点世界切线
		m33(animatedTangent.xyz, animatedTangent, matrix);
		//标准化顶点世界切线
		nrm(animatedTangent.xyz, animatedTangent);

		//计算切线x
		mov(tangentVarying.x, animatedTangent.x);
		//计算切线z
		mov(tangentVarying.z, animatedNormal.x);
		//计算切线w
		mov(tangentVarying.w, normalInput.w);
		//计算双切线x
		mov(bitangentVarying.x, animatedTangent.y);
		//计算双切线z
		mov(bitangentVarying.z, animatedNormal.y);
		//计算双切线w
		mov(bitangentVarying.w, normalInput.w);
		//计算法线x
		mov(normalVarying.x, animatedTangent.z);
		//计算法线z
		mov(normalVarying.z, animatedNormal.z);
		//计算法线w
		mov(normalVarying.w, normalInput.w);
		//计算双切线
		crs(bitanTemp.xyz, animatedNormal, animatedTangent);
		//计算切线y
		mov(tangentVarying.y, bitanTemp.x);
		//计算双切线y
		mov(bitangentVarying.y, bitanTemp.y);
		//计算法线y
		mov(normalVarying.y, bitanTemp.z);

		removeTemp(animatedNormal);
		removeTemp(animatedTangent);
		removeTemp(bitanTemp);
	}

}
