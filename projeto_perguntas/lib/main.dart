

import 'package:flutter/material.dart';
import './questionario.dart';
import './resultado.dart';

main() => runApp(PerguntaApp());

class _PerguntaAppState extends State<PerguntaApp> {

    var _perguntaSelecionada = 0;
    var _pontuacaoTotal = 0;
    
    final _perguntas = const [
        {
            'texto': 'Qual é a sua cor favorita?',
            'respostas': [
                {'texto': 'Preto', 'pontuacao': 5},
                {'texto': 'Vermelho', 'pontuacao': 3},
                {'texto': 'Verde', 'pontuacao': 1},
                {'texto': 'Branco', 'pontuacao': 10},
            ]
        },
        {
            'texto': 'Qual é o seu animal favorito?',
            'respostas': [
                {'texto': 'Coelho', 'pontuacao': 10},
                {'texto': 'Cobra', 'pontuacao': 5},
                {'texto': 'Elefante', 'pontuacao': 3},
                {'texto': 'Mico Leão Dourado', 'pontuacao': 1},
            ]
        },
        {
            'texto': 'Qual é o seu instrutor favorito?',
            'respostas': [
                {'texto': 'Leonardo', 'pontuacao': 10},
                {'texto': 'Bonieky', 'pontuacao': 5},
                {'texto': 'Ferreto', 'pontuacao': 3},
                {'texto': 'Jubilut', 'pontuacao': 1},
            ]
        }
    ];

    bool get temPerguntaSelecionada {
        return _perguntaSelecionada < _perguntas.length;
    }

    void _responder(int pontuacao) {
        if(temPerguntaSelecionada){
            setState(() {
                _perguntaSelecionada++;
                _pontuacaoTotal += pontuacao;
            });
        }
    }

    void _reiniciarQuestionario() {
        setState(() {
          _perguntaSelecionada = 0;
         _pontuacaoTotal = 0;
        });
    }

    @override
    Widget build(BuildContext context) {

        // final List<Map<String, Object>> 

        List<Map<String, Object>> respostas = temPerguntaSelecionada ? _perguntas[_perguntaSelecionada].cast()['respostas'] : [];

        // for(String textoResp in respostas){
        //     widgets.add(Resposta(textoResp, _responder));    
        // }


        return MaterialApp(
            home: Scaffold(
                appBar: AppBar(
                    title: Text('Perguntas'),
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                ),
                body: temPerguntaSelecionada ? Questionario(
                    perguntas: _perguntas,
                    perguntaSelecionada: _perguntaSelecionada,
                    quandoResponder: _responder,
                ) : Resultado(_pontuacaoTotal, _reiniciarQuestionario),
            ),
        );
    }
}

class PerguntaApp extends StatefulWidget {

    _PerguntaAppState createState() {
        return _PerguntaAppState();
    }
    
}