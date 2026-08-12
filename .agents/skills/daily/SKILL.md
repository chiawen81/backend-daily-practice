---
name: daily
description: Use when initializing the next independent .NET Console daily exercise in the backend-daily-practice repository.
---

# Daily Exercise Initialization

Initialize only the next coding environment. Do not generate an exercise, syllabus, learning progress, solution, commit, or push.

1. Resolve the Git repository root and confirm it is `backend-daily-practice`.
2. Run the bundled script from the repository root:

```powershell
$repoRoot = (git rev-parse --show-toplevel).Trim()
& (Join-Path $repoRoot '.agents\skills\daily\scripts\New-DailyExercise.ps1') -RepositoryRoot $repoRoot
```

3. Let the script exclusively determine the latest `dayXX`, validate cleanup targets, remove its `bin/` and `obj/`, create the next Console project, and run it.
4. Stop and report the script error without guessing, deleting additional files, or modifying an existing Daily.
5. Report the cleaned Daily, created project, and `dotnet run` result.
