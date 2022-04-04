//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
pragma experimental ABIEncoderV2;
//Estos son los candidatos(ejemplo) con los que trabajaremos el Smart Contract

/* Nombre  Edad   DNI/ID
// Jose     28    71298L
// Carol    26    76792Y
// Juan     32    45485C
// Pedro    45    12458P
*/

contract votacion{

    //Direccion del propietario del contrato
      address owner;

      constructor() public{
          owner = msg.sender;
      }
    
    //Relacion entre el nombre del canditato y el hash de sus datos personales
    mapping (string=>bytes32) ID_Candidato;

    //Relacion entre el nombre del candidato y el numero de votos que ha tenido
    mapping (string=>uint) votos_Candidato;
    
    //Lista con todos los candidatos que se presentan a elecciones. Lo hacemos en array dinámico
    string [] candidatos;

    //Lista de los votantes, creamos otro array dinámico, a los votantes se les identificará mediante el hash de su address, ya que es anónimo
    bytes32 [] votantes;
    
    //Funcion para que cualquier persona pueda presentarse como candidato a las elecciones
    function Representar(string memory _nombreCandidato, uint _edad, string memory _id_Persona) public{
      
      // Calculamos el hash de los datos que pasamos en la funcion  
      bytes32 hash_Candidato = keccak256(abi.encodePacked(_nombreCandidato, _edad, _id_Persona));
      
      // Gracias al mapping relacionamos el hash del candidato ligado a su nombre
      ID_Candidato[_nombreCandidato] = hash_Candidato;
      
      //Almacenamos en el array el nombre del nuevo candidato
      candidatos.push(_nombreCandidato);
     
    }
    
    //Funcion para ver a los candidatos 
    function verCandidatos() public view returns(string[] memory){
     return candidatos;
    }
    
    //Funcion que nos permite votar a un candidato
    function votar(string memory _candidato) public{
        //Primero calculamos el hash de la direccion de la persona/votante que ejecuta la funcion
      bytes32 hash_Votante = keccak256(abi.encodePacked(msg.sender));
      //verificamos si el votante ya ha votado comparando su hash con el array de votantes mediante un bucle for
      for(uint i=0; i<votantes.length; i++){
        require(votantes[i]!=hash_Votante, "Ya has votado previamente");
    }
    //En caso de que no haya votado almacenamos al votante en el array
    votantes.push(hash_Votante);
    //Añadimos un voto al candidato seleccionado mediante el mapping votos candidato
    votos_Candidato[_candidato]++;

    }
    
    //Nos indica el numero de votos que tiene un candidato
    function VerVotos(string memory _candidato) public view returns (uint){
        return votos_Candidato[_candidato];
    
    }
   
   //Funcion auxiliar que transforma un uint a un string para la funcion ver los resultados
 function toString(uint256 value) internal pure returns (string memory) {
       
        if (value == 0) {
            return "0";
        }
        uint256 temp = value;
        uint256 digits;
        while (temp != 0) {
            digits++;
            temp /= 10;
        }
        bytes memory buffer = new bytes(digits);
        while (value != 0) {
            digits -= 1;
            buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
            value /= 10;
        }
        return string(buffer);
    }
   
    //Ver los votos de cada uno de los candidatos
    function VerResultados() public view returns(string memory){
      //Guardamos en una variable string los candidatos con sus respectivos votos
      string memory resultados="";
      //Recorremos el array de candidatos para actualizar el string de resultados
      for(uint i=0; i<candidatos.length; i++){
          //Actualizamos el string resultados y añadimos el candidato que ocupa la posicion"i" del array candidatos y su numero de votos
        resultados = string(abi.encodePacked(resultados, "(", candidatos[i], ", ", toString(VerVotos(candidatos[i])), ") ---"));
      }
      return resultados;
    }

      //Funcion para proporcionar el nombre del Ganador
    function Ganador() public view returns(string memory){
    //La variable ganador va a contener el nombre del candidato electo
    string memory ganador=candidatos[0];  
    bool flag;
    //Recorremos el array de candidatos para ver quien es el candidato con más votos
    for(uint i=1; i<candidatos.length; i++){
     
     //Comparamos si nuestro ganador ha sido superado por otro candidato
     if(votos_Candidato[ganador]< votos_Candidato[candidatos[i]]){
         ganador = candidatos[i];
         flag=false;
     }else{
         //Miramos si hay empate con otros candidatos
         if(votos_Candidato[ganador] == votos_Candidato[candidatos[i]]){
            flag=true;
         }
     }
    }
    if(flag==true){
        ganador="Hay un empate entre los candidatos!";       
    }
    return ganador;

    }
    


}