# Estructura de la metodología

## Principio fundamental
Lo que Lars deposite en el knowledge base es la fuente de verdad irrefutable. No se complementa con frameworks externos, normas ISO ni criterios genéricos.

## Estructura del JSON de sesión
```json
{
  "_meta": { "system", "exportDate", "session", "totalSessions" },
  "methodology": [
    {
      "id": "s1",
      "title": "...",
      "markedDone": false,
      "questions": [
        {
          "id": "q1_1",
          "text": "...",
          "fieldTypeUsed": "Texto libre",
          "fieldTypeFeedback": null,
          "answer": "...",
          "example": "..."
        }
      ]
    }
  ],
  "structuralFeedback": {
    "sectionOrderOriginal": [],
    "sectionOrderLars": [],
    "reordered": false,
    "sectionNotes": {},
    "proposedSections": []
  },
  "sessions": []
}
```

## Reglas de calidad de respuesta
- Respuesta insuficiente: menos de 15 palabras en preguntas de texto libre
- Respuesta vaga: ausencia de ejemplos concretos en preguntas marcadas como críticas
- Sección completa: markedDone === true Y todas las preguntas con answer !== null
